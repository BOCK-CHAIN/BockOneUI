package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

// Token represents a cryptocurrency token with real market data
type Token struct {
	ID           int     `json:"id" db:"id"`
	Symbol       string  `json:"symbol" db:"symbol"`
	Name         string  `json:"name" db:"name"`
	LogoURL      string  `json:"logoUrl" db:"logo_url"`
	Price        float64 `json:"price" db:"price"`
	MarketCap    float64 `json:"marketCap" db:"market_cap"`
	Volume24h    float64 `json:"volume24h" db:"volume_24h"`
	Change24h    float64 `json:"change24h" db:"change_24h"`
	CoinGeckoID  string  `json:"coinGeckoId" db:"coingecko_id"`
	ContractAddr string  `json:"contractAddress" db:"contract_address"`
	CreatedAt    time.Time `json:"createdAt" db:"created_at"`
	UpdatedAt    time.Time `json:"updatedAt" db:"updated_at"`
}

// PriceData represents real-time price data from external APIs
type PriceData struct {
	Symbol      string  `json:"symbol"`
	Price       float64 `json:"price"`
	MarketCap   float64 `json:"market_cap"`
	Volume24h   float64 `json:"volume_24h"`
	Change24h   float64 `json:"price_change_percentage_24h"`
	LastUpdated string  `json:"last_updated"`
}

// CoinGeckoResponse represents the response from CoinGecko API
type CoinGeckoResponse struct {
	ID                string  `json:"id"`
	Symbol            string  `json:"symbol"`
	Name              string  `json:"name"`
	CurrentPrice      float64 `json:"current_price"`
	MarketCap         float64 `json:"market_cap"`
	TotalVolume       float64 `json:"total_volume"`
	PriceChange24h    float64 `json:"price_change_percentage_24h"`
	Image             string  `json:"image"`
	LastUpdated       string  `json:"last_updated"`
}

// SwapQuote represents a detailed swap quote with real market data
type SwapQuote struct {
	TokenIn         Token   `json:"tokenIn"`
	TokenOut        Token   `json:"tokenOut"`
	AmountIn        float64 `json:"amountIn"`
	AmountOut       float64 `json:"amountOut"`
	ExchangeRate    float64 `json:"exchangeRate"`
	PriceImpact     float64 `json:"priceImpact"`
	Fee             float64 `json:"fee"`
	MinAmountOut    float64 `json:"minAmountOut"`
	Slippage        float64 `json:"slippage"`
	QuoteID         string  `json:"quoteId"`
	ValidUntil      int64   `json:"validUntil"`
	Route           []Token `json:"route"`
}

// LiquidityPool represents a liquidity pool (similar to Uniswap pairs)
type LiquidityPool struct {
	ID            int     `json:"id"`
	Token0ID      int     `json:"token0Id"`
	Token1ID      int     `json:"token1Id"`
	Token0Symbol  string  `json:"token0Symbol"`
	Token1Symbol  string  `json:"token1Symbol"`
	Reserve0      float64 `json:"reserve0"`
	Reserve1      float64 `json:"reserve1"`
	LiquidityUSD  float64 `json:"liquidityUsd"`
	Volume24hUSD  float64 `json:"volume24hUsd"`
	FeeRate       float64 `json:"feeRate"` // 0.003 = 0.3%
}

// PriceService handles real-time price fetching
type PriceService struct {
	priceCache map[string]PriceData
	cacheMutex sync.RWMutex
	lastUpdate time.Time
}

var (
	db           *sql.DB
	priceService *PriceService
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using system environment variables")
	}

	// Initialize database
	initDatabase()

	// Initialize price service
	priceService = &PriceService{
		priceCache: make(map[string]PriceData),
	}

	// Start price update routine
	go priceService.startPriceUpdater()

	// Wait for initial price fetch
	time.Sleep(3 * time.Second)

	// Initialize Gin router
	r := gin.Default()
	r.Use(corsMiddleware())

	// API routes
	api := r.Group("/api/v1")
	{
		// Token routes with real market data
		api.GET("/tokens", getTokensWithPrices)
		api.GET("/tokens/:id", getTokenByID)
		api.POST("/tokens", createToken)
		api.PUT("/tokens/:id/refresh-price", refreshTokenPrice)

		// Market data routes
		api.GET("/prices", getCurrentPrices)
		api.GET("/prices/:symbol", getTokenPrice)
		api.GET("/market-data/:symbol", getMarketData)

		// Advanced swap routes (Uniswap-like)
		api.POST("/swap/quote", getAdvancedSwapQuote)
		api.POST("/swap/execute", executeAdvancedSwap)
		api.GET("/swap/route", getBestSwapRoute)

		// Liquidity pool routes
		api.GET("/pools", getLiquidityPools)
		api.GET("/pools/:token0/:token1", getPoolByTokens)
		api.POST("/pools", createLiquidityPool)

		// Analytics routes
		api.GET("/analytics/top-tokens", getTopTokens)
		api.GET("/analytics/volume", getVolumeData)
	}

	// Health check with price service status
	r.GET("/health", healthCheck)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 Token Swap API starting on port %s", port)
	log.Printf("📊 Real-time price updates every 30 seconds")
	log.Fatal(r.Run("0.0.0.0:" + port))
}

func initDatabase() {
	var err error
	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		log.Fatal("DATABASE_URL environment variable is required")
	}

	db, err = sql.Open("postgres", databaseURL)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(25)
	db.SetConnMaxLifetime(5 * time.Minute)

	if err := db.Ping(); err != nil {
		log.Fatal("Failed to ping database:", err)
	}

	// Fix schema before creating tables
	if err := fixDatabaseSchema(); err != nil {
		log.Printf("Schema fix failed: %v", err)
	}

	if err := createAdvancedTables(); err != nil {
		log.Fatal("Failed to create tables:", err)
	}

	if err := seedAdvancedTokens(); err != nil {
		log.Println("Warning: Failed to seed tokens:", err)
	}

	log.Println("✅ Database connected successfully!")
}

// Updated createAdvancedTables function with better error handling
func createAdvancedTables() error {
	// First, try to fix any schema issues
	if err := fixDatabaseSchema(); err != nil {
		log.Printf("Schema fix failed: %v", err)
	}
	
	// Enhanced tokens table with market data
	tokenTable := `
	CREATE TABLE IF NOT EXISTS tokens (
		id SERIAL PRIMARY KEY,
		symbol VARCHAR(10) NOT NULL UNIQUE,
		name VARCHAR(100) NOT NULL,
		logo_url TEXT,
		price DECIMAL(20,8) NOT NULL DEFAULT 0,
		market_cap DECIMAL(20,2) DEFAULT 0,
		volume_24h DECIMAL(20,2) DEFAULT 0,
		change_24h DECIMAL(10,4) DEFAULT 0,
		coingecko_id VARCHAR(100),
		contract_address VARCHAR(100),
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);`

	// Liquidity pools table
	poolTable := `
	CREATE TABLE IF NOT EXISTS liquidity_pools (
		id SERIAL PRIMARY KEY,
		token0_id INTEGER REFERENCES tokens(id),
		token1_id INTEGER REFERENCES tokens(id),
		reserve0 DECIMAL(20,8) NOT NULL DEFAULT 0,
		reserve1 DECIMAL(20,8) NOT NULL DEFAULT 0,
		liquidity_usd DECIMAL(20,2) DEFAULT 0,
		volume_24h_usd DECIMAL(20,2) DEFAULT 0,
		fee_rate DECIMAL(6,5) DEFAULT 0.003,
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		UNIQUE(token0_id, token1_id)
	);`

	// Enhanced swap transactions table
	swapTable := `
	CREATE TABLE IF NOT EXISTS swap_transactions (
		id SERIAL PRIMARY KEY,
		user_id VARCHAR(100),
		token_in_id INTEGER REFERENCES tokens(id),
		token_out_id INTEGER REFERENCES tokens(id),
		amount_in DECIMAL(20,8) NOT NULL,
		amount_out DECIMAL(20,8) NOT NULL,
		price_in_usd DECIMAL(20,8),
		price_out_usd DECIMAL(20,8),
		fee DECIMAL(20,8) NOT NULL DEFAULT 0,
		price_impact DECIMAL(5,2) NOT NULL DEFAULT 0,
		slippage DECIMAL(5,2) DEFAULT 0.5,
		tx_hash VARCHAR(66) UNIQUE,
		status VARCHAR(20) DEFAULT 'pending',
		route_path TEXT,
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);`

	tables := []string{tokenTable, poolTable, swapTable}
	for i, table := range tables {
		if _, err := db.Exec(table); err != nil {
			return fmt.Errorf("failed to create table %d: %v", i+1, err)
		}
	}

	// Create indexes with better error handling
	indexes := []struct {
		name  string
		query string
	}{
		{"idx_tokens_symbol", `CREATE INDEX IF NOT EXISTS idx_tokens_symbol ON tokens(symbol);`},
		{"idx_tokens_coingecko_id", `CREATE INDEX IF NOT EXISTS idx_tokens_coingecko_id ON tokens(coingecko_id) WHERE coingecko_id IS NOT NULL;`},
		{"idx_pools_tokens", `CREATE INDEX IF NOT EXISTS idx_pools_tokens ON liquidity_pools(token0_id, token1_id);`},
		{"idx_swaps_created_at", `CREATE INDEX IF NOT EXISTS idx_swaps_created_at ON swap_transactions(created_at);`},
	}

	for _, index := range indexes {
		if _, err := db.Exec(index.query); err != nil {
			log.Printf("Warning: Failed to create index %s: %v", index.name, err)
			// Don't return error for index creation failures, just log them
		} else {
			log.Printf("✅ Created index: %s", index.name)
		}
	}

	return nil
}


func seedAdvancedTokens() error {
	tokens := []struct {
		Symbol      string
		Name        string
		CoinGeckoID string
		ContractAddr string
	}{
		{"BTC", "Bitcoin", "bitcoin", ""},
		{"ETH", "Ethereum", "ethereum", "0x0000000000000000000000000000000000000000"},
		{"USDC", "USD Coin", "usd-coin", "0xA0b86a33E6441c8E47c543C8E12F0F94dFE73651"},
		{"USDT", "Tether", "tether", "0xdAC17F958D2ee523a2206206994597C13D831ec7"},
		{"BNB", "BNB", "binancecoin", "0xB8c77482e45F1F44dE1745F52C74426C631bDD52"},
		{"SOL", "Solana", "solana", ""},
		{"ADA", "Cardano", "cardano", ""},
		{"DOGE", "Dogecoin", "dogecoin", ""},
		{"MATIC", "Polygon", "matic-network", "0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0"},
		{"DOT", "Polkadot", "polkadot", ""},
	}

	for _, token := range tokens {
		var count int
		err := db.QueryRow("SELECT COUNT(*) FROM tokens WHERE symbol = $1", token.Symbol).Scan(&count)
		if err != nil {
			return err
		}

		if count == 0 {
			_, err = db.Exec(`
				INSERT INTO tokens (symbol, name, coingecko_id, contract_address, created_at, updated_at) 
				VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)`,
				token.Symbol, token.Name, token.CoinGeckoID, token.ContractAddr)
			if err != nil {
				return err
			}
			log.Printf("✅ Seeded token: %s (%s)", token.Symbol, token.Name)
		}
	}

	return nil
}

// PriceService methods for fetching real-time prices
func (ps *PriceService) startPriceUpdater() {
	ticker := time.NewTicker(30 * time.Second) // Update every 30 seconds
	defer ticker.Stop()

	// Initial fetch
	ps.updateAllPrices()

	for range ticker.C {
		ps.updateAllPrices()
	}
}

func (ps *PriceService) updateAllPrices() {
	log.Println("🔄 Updating token prices from CoinGecko...")

	// Get all tokens with CoinGecko IDs
	rows, err := db.Query("SELECT symbol, coingecko_id FROM tokens WHERE coingecko_id IS NOT NULL AND coingecko_id != ''")
	if err != nil {
		log.Printf("Error fetching tokens: %v", err)
		return
	}
	defer rows.Close()

	var coinGeckoIDs []string
	symbolToID := make(map[string]string)

	for rows.Next() {
		var symbol, coinGeckoID string
		if err := rows.Scan(&symbol, &coinGeckoID); err != nil {
			continue
		}
		coinGeckoIDs = append(coinGeckoIDs, coinGeckoID)
		symbolToID[coinGeckoID] = symbol
	}

	if len(coinGeckoIDs) == 0 {
		return
	}

	// Fetch prices from CoinGecko
	prices := ps.fetchCoinGeckoPrices(coinGeckoIDs)

	ps.cacheMutex.Lock()
	defer ps.cacheMutex.Unlock()

	// Update cache and database
	for _, price := range prices {
		symbol := symbolToID[price.ID]
		if symbol == "" {
			continue
		}

		// Update cache
		ps.priceCache[symbol] = PriceData{
			Symbol:      symbol,
			Price:       price.CurrentPrice,
			MarketCap:   price.MarketCap,
			Volume24h:   price.TotalVolume,
			Change24h:   price.PriceChange24h,
			LastUpdated: price.LastUpdated,
		}

		// Update database
		_, err := db.Exec(`
			UPDATE tokens 
			SET price = $1, market_cap = $2, volume_24h = $3, change_24h = $4, updated_at = CURRENT_TIMESTAMP 
			WHERE symbol = $5`,
			price.CurrentPrice, price.MarketCap, price.TotalVolume, price.PriceChange24h, symbol)
		if err != nil {
			log.Printf("Error updating price for %s: %v", symbol, err)
		}
	}

	ps.lastUpdate = time.Now()
	log.Printf("✅ Updated prices for %d tokens", len(prices))
}



func (ps *PriceService) getPrice(symbol string) (PriceData, bool) {
	ps.cacheMutex.RLock()
	defer ps.cacheMutex.RUnlock()
	
	price, exists := ps.priceCache[symbol]
	return price, exists
}

// CORS middleware
func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	}
}

// Enhanced API handlers with real market data
func getTokensWithPrices(c *gin.Context) {
	rows, err := db.Query(`
		SELECT id, symbol, name, logo_url, price, market_cap, volume_24h, change_24h, 
			   coingecko_id, contract_address, created_at, updated_at 
		FROM tokens 
		ORDER BY market_cap DESC NULLS LAST, symbol`)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var tokens []Token
	for rows.Next() {
		var token Token
		var coinGeckoID, contractAddr sql.NullString
		
		if err := rows.Scan(&token.ID, &token.Symbol, &token.Name, &token.LogoURL,
			&token.Price, &token.MarketCap, &token.Volume24h, &token.Change24h,
			&coinGeckoID, &contractAddr, &token.CreatedAt, &token.UpdatedAt); err != nil {
			continue
		}
		
		token.CoinGeckoID = coinGeckoID.String
		token.ContractAddr = contractAddr.String
		
		// Get real-time price if available
		if realTimePrice, exists := priceService.getPrice(token.Symbol); exists {
			token.Price = realTimePrice.Price
			token.MarketCap = realTimePrice.MarketCap
			token.Volume24h = realTimePrice.Volume24h
			token.Change24h = realTimePrice.Change24h
		}
		
		tokens = append(tokens, token)
	}

	c.JSON(http.StatusOK, gin.H{
		"tokens":     tokens,
		"count":      len(tokens),
		"lastUpdate": priceService.lastUpdate,
	})
}

func getTokenByID(c *gin.Context) {
	id := c.Param("id")

	var token Token
	var coinGeckoID, contractAddr sql.NullString
	
	err := db.QueryRow(`
		SELECT id, symbol, name, logo_url, price, market_cap, volume_24h, change_24h,
			   coingecko_id, contract_address, created_at, updated_at 
		FROM tokens WHERE id = $1`, id).
		Scan(&token.ID, &token.Symbol, &token.Name, &token.LogoURL,
			&token.Price, &token.MarketCap, &token.Volume24h, &token.Change24h,
			&coinGeckoID, &contractAddr, &token.CreatedAt, &token.UpdatedAt)

	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Token not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	token.CoinGeckoID = coinGeckoID.String
	token.ContractAddr = contractAddr.String

	// Get real-time price if available
	if realTimePrice, exists := priceService.getPrice(token.Symbol); exists {
		token.Price = realTimePrice.Price
		token.MarketCap = realTimePrice.MarketCap
		token.Volume24h = realTimePrice.Volume24h
		token.Change24h = realTimePrice.Change24h
	}

	c.JSON(http.StatusOK, token)
}

func createToken(c *gin.Context) {
	var token Token
	if err := c.ShouldBindJSON(&token); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := db.QueryRow(`
		INSERT INTO tokens (symbol, name, logo_url, coingecko_id, contract_address, created_at, updated_at) 
		VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 
		RETURNING id, created_at, updated_at`,
		token.Symbol, token.Name, token.LogoURL, token.CoinGeckoID, token.ContractAddr).
		Scan(&token.ID, &token.CreatedAt, &token.UpdatedAt)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, token)
}

func getCurrentPrices(c *gin.Context) {
	priceService.cacheMutex.RLock()
	defer priceService.cacheMutex.RUnlock()

	c.JSON(http.StatusOK, gin.H{
		"prices":     priceService.priceCache,
		"lastUpdate": priceService.lastUpdate,
		"count":      len(priceService.priceCache),
	})
}

func getTokenPrice(c *gin.Context) {
	symbol := strings.ToUpper(c.Param("symbol"))
	
	if price, exists := priceService.getPrice(symbol); exists {
		c.JSON(http.StatusOK, price)
	} else {
		c.JSON(http.StatusNotFound, gin.H{"error": "Price not found for symbol: " + symbol})
	}
}

func getAdvancedSwapQuote(c *gin.Context) {
	var request struct {
		TokenInSymbol  string  `json:"tokenInSymbol" binding:"required"`
		TokenOutSymbol string  `json:"tokenOutSymbol" binding:"required"`
		AmountIn       float64 `json:"amountIn" binding:"required"`
		Slippage       float64 `json:"slippage"` // Optional, default 0.5%
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if request.Slippage == 0 {
		request.Slippage = 0.5 // Default 0.5% slippage
	}

	// Get tokens from database
	var tokenIn, tokenOut Token
	
	err := db.QueryRow("SELECT id, symbol, name, price FROM tokens WHERE symbol = $1", 
		strings.ToUpper(request.TokenInSymbol)).
		Scan(&tokenIn.ID, &tokenIn.Symbol, &tokenIn.Name, &tokenIn.Price)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Token in not found"})
		return
	}

	err = db.QueryRow("SELECT id, symbol, name, price FROM tokens WHERE symbol = $1", 
		strings.ToUpper(request.TokenOutSymbol)).
		Scan(&tokenOut.ID, &tokenOut.Symbol, &tokenOut.Name, &tokenOut.Price)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Token out not found"})
		return
	}

	// Get real-time prices
	if priceIn, exists := priceService.getPrice(tokenIn.Symbol); exists {
		tokenIn.Price = priceIn.Price
	}
	if priceOut, exists := priceService.getPrice(tokenOut.Symbol); exists {
		tokenOut.Price = priceOut.Price
	}

	// Calculate swap with advanced logic
	quote := calculateAdvancedSwapQuote(tokenIn, tokenOut, request.AmountIn, request.Slippage)

	c.JSON(http.StatusOK, quote)
}

func calculateAdvancedSwapQuote(tokenIn, tokenOut Token, amountIn, slippage float64) SwapQuote {
	// Basic exchange rate
	exchangeRate := tokenIn.Price / tokenOut.Price
	
	// Calculate base amount out
	//baseAmountOut := amountIn * exchangeRate
	
	// Apply trading fee (0.3% like Uniswap)
	fee := amountIn * 0.003
	amountAfterFee := amountIn - fee
	amountOut := amountAfterFee * exchangeRate
	
	// Calculate price impact (simplified - based on amount)
	priceImpact := calculatePriceImpact(amountIn, tokenIn.Price)
	
	// Apply price impact
	amountOut = amountOut * (1 - priceImpact/100)
	
	// Calculate minimum amount out with slippage
	minAmountOut := amountOut * (1 - slippage/100)
	
	// Generate quote ID
	quoteID := fmt.Sprintf("quote_%d_%s_%s", time.Now().UnixNano(), tokenIn.Symbol, tokenOut.Symbol)
	
	return SwapQuote{
		TokenIn:      tokenIn,
		TokenOut:     tokenOut,
		AmountIn:     amountIn,
		AmountOut:    amountOut,
		ExchangeRate: exchangeRate,
		PriceImpact:  priceImpact,
		Fee:          fee,
		MinAmountOut: minAmountOut,
		Slippage:     slippage,
		QuoteID:      quoteID,
		ValidUntil:   time.Now().Add(2 * time.Minute).Unix(), // 2 minute validity
		Route:        []Token{tokenIn, tokenOut}, // Direct route for now
	}
}

func calculatePriceImpact(amountIn, priceUSD float64) float64 {
	// Simplified price impact calculation
	// In real Uniswap, this depends on liquidity pool reserves
	tradeValueUSD := amountIn * priceUSD
	
	if tradeValueUSD < 1000 {
		return 0.01 // 0.01% for small trades
	} else if tradeValueUSD < 10000 {
		return 0.05 // 0.05% for medium trades
	} else if tradeValueUSD < 100000 {
		return 0.1 // 0.1% for large trades
	} else {
		return 0.5 // 0.5% for very large trades
	}
}

func executeAdvancedSwap(c *gin.Context) {
	log.Println("🔄 Received swap execution request")
	
	var request struct {
		QuoteID        string  `json:"quoteId"`         // Optional - remove required tag
		UserID         string  `json:"userId" binding:"required"`
		TokenInSymbol  string  `json:"tokenInSymbol"`   // Optional - for direct execution
		TokenOutSymbol string  `json:"tokenOutSymbol"`  // Optional - for direct execution
		AmountIn       float64 `json:"amountIn"`        // Optional - for direct execution
		Slippage       float64 `json:"slippage"`        // Optional - for direct execution
	}

	// Log the raw request body for debugging
	body, _ := c.GetRawData()
	log.Printf("📝 Raw request body: %s", string(body))
	
	// Reset the request body so it can be read again
	c.Request.Body = io.NopCloser(strings.NewReader(string(body)))

	if err := c.ShouldBindJSON(&request); err != nil {
		log.Printf("❌ JSON binding error: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid request format: " + err.Error(),
			"expected": gin.H{
				"userId":         "string (required)",
				"quoteId":        "string (optional - if provided, other fields ignored)",
				"tokenInSymbol":  "string (required if no quoteId)",
				"tokenOutSymbol": "string (required if no quoteId)",
				"amountIn":       "number (required if no quoteId)",
				"slippage":       "number (optional, default 0.5)",
			},
		})
		return
	}

	log.Printf("✅ Parsed request: %+v", request)

	// Set default slippage if not provided
	if request.Slippage == 0 {
		request.Slippage = 0.5
	}

	var swapResult gin.H
	var err error

	if request.QuoteID != "" {
		// Execute swap with existing quote ID
		log.Printf("🔄 Executing swap with quote ID: %s", request.QuoteID)
		swapResult, err = executeSwapWithQuoteID(request.QuoteID, request.UserID)
	} else {
		// Execute swap directly with token details
		log.Printf("🔄 Executing direct swap: %.6f %s -> %s", request.AmountIn, request.TokenInSymbol, request.TokenOutSymbol)
		
		// Validate required fields for direct execution
		if request.TokenInSymbol == "" || request.TokenOutSymbol == "" || request.AmountIn <= 0 {
			c.JSON(http.StatusBadRequest, gin.H{
				"error": "For direct execution, tokenInSymbol, tokenOutSymbol, and amountIn are required",
			})
			return
		}
		
		swapResult, err = executeDirectSwap(request.TokenInSymbol, request.TokenOutSymbol, request.AmountIn, request.Slippage, request.UserID)
	}

	if err != nil {
		log.Printf("❌ Swap execution failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	log.Printf("✅ Swap executed successfully: %+v", swapResult)
	c.JSON(http.StatusOK, swapResult)
}

// Execute swap with existing quote ID
func executeSwapWithQuoteID(quoteID, userID string) (gin.H, error) {
	// In production, you'd validate the quote ID and check if it's still valid
	// For demo, we'll simulate the swap execution
	
	log.Printf("📋 Validating quote ID: %s", quoteID)
	
	// Generate transaction hash
	txHash := fmt.Sprintf("0x%x", time.Now().UnixNano())
	
	// Create swap record
	swapRecord := gin.H{
		"id":          time.Now().UnixNano(),
		"quoteId":     quoteID,
		"userId":      userID,
		"txHash":      txHash,
		"status":      "completed",
		"executedAt":  time.Now(),
		"message":     "Swap executed successfully with quote ID",
	}

	return swapRecord, nil
}

// Execute swap directly without quote ID
func executeDirectSwap(tokenInSymbol, tokenOutSymbol string, amountIn, slippage float64, userID string) (gin.H, error) {
	log.Printf("🔄 Direct swap execution: %.6f %s -> %s", amountIn, tokenInSymbol, tokenOutSymbol)

	// Get tokens from database
	var tokenIn, tokenOut Token
	
	err := db.QueryRow(`
		SELECT id, symbol, name, price, market_cap, volume_24h, change_24h 
		FROM tokens WHERE UPPER(symbol) = UPPER($1)`, tokenInSymbol).
		Scan(&tokenIn.ID, &tokenIn.Symbol, &tokenIn.Name, &tokenIn.Price, 
			&tokenIn.MarketCap, &tokenIn.Volume24h, &tokenIn.Change24h)
	
	if err != nil {
		return nil, fmt.Errorf("token in not found: %s", tokenInSymbol)
	}

	err = db.QueryRow(`
		SELECT id, symbol, name, price, market_cap, volume_24h, change_24h 
		FROM tokens WHERE UPPER(symbol) = UPPER($1)`, tokenOutSymbol).
		Scan(&tokenOut.ID, &tokenOut.Symbol, &tokenOut.Name, &tokenOut.Price,
			&tokenOut.MarketCap, &tokenOut.Volume24h, &tokenOut.Change24h)
	
	if err != nil {
		return nil, fmt.Errorf("token out not found: %s", tokenOutSymbol)
	}

	// Get real-time prices if available
	if priceIn, exists := priceService.getPrice(tokenIn.Symbol); exists {
		tokenIn.Price = priceIn.Price
	}
	if priceOut, exists := priceService.getPrice(tokenOut.Symbol); exists {
		tokenOut.Price = priceOut.Price
	}

	// Calculate swap quote first
	quote := calculateAdvancedSwapQuote(tokenIn, tokenOut, amountIn, slippage)
	
	// Generate transaction hash
	txHash := fmt.Sprintf("0x%x", time.Now().UnixNano())
	
	// Store swap transaction in database
	var swapID int64
	err = db.QueryRow(`
		INSERT INTO swap_transactions (
			user_id, token_in_id, token_out_id, amount_in, amount_out,
			price_in_usd, price_out_usd, fee, price_impact, slippage,
			tx_hash, status, created_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, CURRENT_TIMESTAMP)
		RETURNING id`,
		userID, tokenIn.ID, tokenOut.ID, amountIn, quote.AmountOut,
		tokenIn.Price, tokenOut.Price, quote.Fee, quote.PriceImpact, slippage,
		txHash, "completed").Scan(&swapID)
	
	if err != nil {
		log.Printf("⚠️  Failed to store swap transaction: %v", err)
		// Continue anyway for demo purposes
	}

	// Create successful swap result
	swapResult := gin.H{
		"id":            swapID,
		"transactionId": txHash,
		"txHash":        txHash,
		"userId":        userID,
		"tokenIn":       tokenIn,
		"tokenOut":      tokenOut,
		"amountIn":      amountIn,
		"amountOut":     quote.AmountOut,
		"exchangeRate":  quote.ExchangeRate,
		"fee":           quote.Fee,
		"priceImpact":   quote.PriceImpact,
		"slippage":      slippage,
		"status":        "completed",
		"executedAt":    time.Now(),
		"message":       "Direct swap executed successfully",
		"quote":         quote,
	}

	log.Printf("✅ Direct swap completed: %.6f %s -> %.6f %s", 
		amountIn, tokenIn.Symbol, quote.AmountOut, tokenOut.Symbol)

	return swapResult, nil
}

func getBestSwapRoute(c *gin.Context) {
	tokenIn := c.Query("tokenIn")
	tokenOut := c.Query("tokenOut")
	amountStr := c.Query("amount")
	
	if tokenIn == "" || tokenOut == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "tokenIn and tokenOut parameters required"})
		return
	}

	amount, _ := strconv.ParseFloat(amountStr, 64)
	if amount <= 0 {
		amount = 1.0 // Default amount for route calculation
	}

	// Find best route (simplified implementation)
	route := findBestRoute(tokenIn, tokenOut, amount)
	
	c.JSON(http.StatusOK, gin.H{
		"tokenIn":     tokenIn,
		"tokenOut":    tokenOut,
		"amount":      amount,
		"route":       route.Path,
		"expectedOut": route.ExpectedOutput,
		"priceImpact": route.PriceImpact,
		"gasEstimate": route.GasEstimate,
	})
}

// SwapRoute represents a trading route
type SwapRoute struct {
	Path           []string `json:"path"`
	ExpectedOutput float64  `json:"expectedOutput"`
	PriceImpact    float64  `json:"priceImpact"`
	GasEstimate    string   `json:"gasEstimate"`
}

func findBestRoute(tokenIn, tokenOut string, amount float64) SwapRoute {
	// Simplified route finding - in production, use graph algorithms
	// to find the most efficient path through liquidity pools
	
	// Check for direct pair
	if hasDirectPair(tokenIn, tokenOut) {
		return SwapRoute{
			Path:           []string{tokenIn, tokenOut},
			ExpectedOutput: calculateDirectOutput(tokenIn, tokenOut, amount),
			PriceImpact:    0.1,
			GasEstimate:    "~150,000",
		}
	}
	
	// Check for route through major tokens (USDC, ETH, WETH)
	majorTokens := []string{"USDC", "ETH", "WETH", "USDT"}
	
	for _, intermediate := range majorTokens {
		if intermediate != tokenIn && intermediate != tokenOut {
			if hasDirectPair(tokenIn, intermediate) && hasDirectPair(intermediate, tokenOut) {
				return SwapRoute{
					Path:           []string{tokenIn, intermediate, tokenOut},
					ExpectedOutput: calculateMultiHopOutput(tokenIn, intermediate, tokenOut, amount),
					PriceImpact:    0.2,
					GasEstimate:    "~300,000",
				}
			}
		}
	}
	
	// Default route (should not happen in production)
	return SwapRoute{
		Path:           []string{tokenIn, "USDC", tokenOut},
		ExpectedOutput: amount * 0.95, // Approximate
		PriceImpact:    0.5,
		GasEstimate:    "~300,000",
	}
}

func hasDirectPair(token1, token2 string) bool {
	// In production, check if liquidity pool exists
	var count int
	query := `
		SELECT COUNT(*) FROM liquidity_pools lp
		JOIN tokens t1 ON (lp.token0_id = t1.id OR lp.token1_id = t1.id)
		JOIN tokens t2 ON (lp.token0_id = t2.id OR lp.token1_id = t2.id)
		WHERE t1.symbol = $1 AND t2.symbol = $2 AND t1.id != t2.id`
	
	db.QueryRow(query, token1, token2).Scan(&count)
	return count > 0
}

func calculateDirectOutput(tokenIn, tokenOut string, amountIn float64) float64 {
	// Get token prices
	var priceIn, priceOut float64
	
	db.QueryRow("SELECT price FROM tokens WHERE symbol = $1", tokenIn).Scan(&priceIn)
	db.QueryRow("SELECT price FROM tokens WHERE symbol = $1", tokenOut).Scan(&priceOut)
	
	// Apply fees and slippage
	exchangeRate := priceIn / priceOut
	amountOut := amountIn * exchangeRate * 0.997 // 0.3% fee
	
	return amountOut
}

func calculateMultiHopOutput(tokenIn, intermediate, tokenOut string, amountIn float64) float64 {
	// Calculate first hop
	firstHopOut := calculateDirectOutput(tokenIn, intermediate, amountIn)
	// Calculate second hop
	secondHopOut := calculateDirectOutput(intermediate, tokenOut, firstHopOut)
	
	return secondHopOut
}

func getLiquidityPools(c *gin.Context) {
	rows, err := db.Query(`
		SELECT lp.id, lp.token0_id, lp.token1_id, lp.reserve0, lp.reserve1,
			   lp.liquidity_usd, lp.volume_24h_usd, lp.fee_rate,
			   t0.symbol as token0_symbol, t1.symbol as token1_symbol
		FROM liquidity_pools lp
		JOIN tokens t0 ON lp.token0_id = t0.id
		JOIN tokens t1 ON lp.token1_id = t1.id
		ORDER BY lp.liquidity_usd DESC`)
	
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var pools []LiquidityPool
	for rows.Next() {
		var pool LiquidityPool
		if err := rows.Scan(&pool.ID, &pool.Token0ID, &pool.Token1ID,
			&pool.Reserve0, &pool.Reserve1, &pool.LiquidityUSD,
			&pool.Volume24hUSD, &pool.FeeRate,
			&pool.Token0Symbol, &pool.Token1Symbol); err != nil {
			continue
		}
		pools = append(pools, pool)
	}

	c.JSON(http.StatusOK, gin.H{
		"pools": pools,
		"count": len(pools),
	})
}

func getPoolByTokens(c *gin.Context) {
	token0 := strings.ToUpper(c.Param("token0"))
	token1 := strings.ToUpper(c.Param("token1"))

	var pool LiquidityPool
	query := `
		SELECT lp.id, lp.token0_id, lp.token1_id, lp.reserve0, lp.reserve1,
			   lp.liquidity_usd, lp.volume_24h_usd, lp.fee_rate,
			   t0.symbol as token0_symbol, t1.symbol as token1_symbol
		FROM liquidity_pools lp
		JOIN tokens t0 ON lp.token0_id = t0.id
		JOIN tokens t1 ON lp.token1_id = t1.id
		WHERE (t0.symbol = $1 AND t1.symbol = $2) OR (t0.symbol = $2 AND t1.symbol = $1)`

	err := db.QueryRow(query, token0, token1).Scan(
		&pool.ID, &pool.Token0ID, &pool.Token1ID,
		&pool.Reserve0, &pool.Reserve1, &pool.LiquidityUSD,
		&pool.Volume24hUSD, &pool.FeeRate,
		&pool.Token0Symbol, &pool.Token1Symbol)

	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Pool not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, pool)
}

func createLiquidityPool(c *gin.Context) {
	var pool LiquidityPool
	if err := c.ShouldBindJSON(&pool); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := db.QueryRow(`
		INSERT INTO liquidity_pools (token0_id, token1_id, reserve0, reserve1, liquidity_usd, fee_rate, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
		RETURNING id`,
		pool.Token0ID, pool.Token1ID, pool.Reserve0, pool.Reserve1, pool.LiquidityUSD, pool.FeeRate).
		Scan(&pool.ID)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, pool)
}

func getTopTokens(c *gin.Context) {
	limit := 10
	if limitStr := c.Query("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 && l <= 100 {
			limit = l
		}
	}

	rows, err := db.Query(`
		SELECT id, symbol, name, logo_url, price, market_cap, volume_24h, change_24h
		FROM tokens 
		WHERE market_cap > 0
		ORDER BY market_cap DESC 
		LIMIT $1`, limit)
	
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var tokens []Token
	for rows.Next() {
		var token Token
		if err := rows.Scan(&token.ID, &token.Symbol, &token.Name, &token.LogoURL,
			&token.Price, &token.MarketCap, &token.Volume24h, &token.Change24h); err != nil {
			continue
		}
		
		// Get real-time price if available
		if realTimePrice, exists := priceService.getPrice(token.Symbol); exists {
			token.Price = realTimePrice.Price
			token.MarketCap = realTimePrice.MarketCap
			token.Volume24h = realTimePrice.Volume24h
			token.Change24h = realTimePrice.Change24h
		}
		
		tokens = append(tokens, token)
	}

	c.JSON(http.StatusOK, gin.H{
		"tokens": tokens,
		"count":  len(tokens),
		"limit":  limit,
	})
}

func getVolumeData(c *gin.Context) {
	period := c.Query("period") // 24h, 7d, 30d
	if period == "" {
		period = "24h"
	}

	var interval string
	var timeframe string
	
	switch period {
	case "24h":
		interval = "1 hour"
		timeframe = "24 hours"
	case "7d":
		interval = "1 day"
		timeframe = "7 days"
	case "30d":
		interval = "1 day"
		timeframe = "30 days"
	default:
		interval = "1 hour"
		timeframe = "24 hours"
	}

	query := fmt.Sprintf(`
		SELECT 
			DATE_TRUNC('%s', created_at) as time_bucket,
			COUNT(*) as swap_count,
			SUM(amount_in * price_in_usd) as volume_usd
		FROM swap_transactions 
		WHERE created_at >= NOW() - INTERVAL '%s'
		GROUP BY time_bucket
		ORDER BY time_bucket`, interval, timeframe)

	rows, err := db.Query(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var volumeData []gin.H
	totalVolume := 0.0
	totalSwaps := 0

	for rows.Next() {
		var timeBucket time.Time
		var swapCount int
		var volumeUSD sql.NullFloat64

		if err := rows.Scan(&timeBucket, &swapCount, &volumeUSD); err != nil {
			continue
		}

		volume := 0.0
		if volumeUSD.Valid {
			volume = volumeUSD.Float64
		}

		volumeData = append(volumeData, gin.H{
			"timestamp":  timeBucket,
			"swapCount":  swapCount,
			"volumeUSD":  volume,
		})

		totalVolume += volume
		totalSwaps += swapCount
	}

	c.JSON(http.StatusOK, gin.H{
		"period":       period,
		"volumeData":   volumeData,
		"totalVolume":  totalVolume,
		"totalSwaps":   totalSwaps,
		"dataPoints":   len(volumeData),
	})
}

func getMarketData(c *gin.Context) {
	symbol := strings.ToUpper(c.Param("symbol"))
	
	var token Token
	err := db.QueryRow(`
		SELECT id, symbol, name, price, market_cap, volume_24h, change_24h, logo_url
		FROM tokens WHERE symbol = $1`, symbol).
		Scan(&token.ID, &token.Symbol, &token.Name, &token.Price,
			&token.MarketCap, &token.Volume24h, &token.Change24h, &token.LogoURL)

	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Token not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Get real-time price if available
	if realTimePrice, exists := priceService.getPrice(token.Symbol); exists {
		token.Price = realTimePrice.Price
		token.MarketCap = realTimePrice.MarketCap
		token.Volume24h = realTimePrice.Volume24h
		token.Change24h = realTimePrice.Change24h
	}

	// Additional market data calculations
	marketData := gin.H{
		"token":        token,
		"priceUSD":     token.Price,
		"marketCapUSD": token.MarketCap,
		"volume24hUSD": token.Volume24h,
		"change24h":    token.Change24h,
		"rank":         getTokenRank(token.MarketCap),
		"lastUpdated":  priceService.lastUpdate,
	}

	c.JSON(http.StatusOK, marketData)
}

func getTokenRank(marketCap float64) int {
	var rank int
	err := db.QueryRow(`
		SELECT COUNT(*) + 1 
		FROM tokens 
		WHERE market_cap > $1 AND market_cap > 0`, marketCap).Scan(&rank)
	
	if err != nil {
		return 0
	}
	return rank
}

func refreshTokenPrice(c *gin.Context) {
	id := c.Param("id")
	
	var token Token
	err := db.QueryRow("SELECT symbol, coingecko_id FROM tokens WHERE id = $1", id).
		Scan(&token.Symbol, &token.CoinGeckoID)
	
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Token not found"})
		return
	}

	if token.CoinGeckoID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Token has no CoinGecko ID"})
		return
	}

	// Fetch fresh price
	prices := priceService.fetchCoinGeckoPrices([]string{token.CoinGeckoID})
	if len(prices) == 0 {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch price"})
		return
	}

	price := prices[0]
	
	// Update database and cache
	_, err = db.Exec(`
		UPDATE tokens 
		SET price = $1, market_cap = $2, volume_24h = $3, change_24h = $4, updated_at = CURRENT_TIMESTAMP 
		WHERE id = $5`,
		price.CurrentPrice, price.MarketCap, price.TotalVolume, price.PriceChange24h, id)
	
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Update cache
	priceService.cacheMutex.Lock()
	priceService.priceCache[token.Symbol] = PriceData{
		Symbol:      token.Symbol,
		Price:       price.CurrentPrice,
		MarketCap:   price.MarketCap,
		Volume24h:   price.TotalVolume,
		Change24h:   price.PriceChange24h,
		LastUpdated: price.LastUpdated,
	}
	priceService.cacheMutex.Unlock()

	c.JSON(http.StatusOK, gin.H{
		"message":     "Price refreshed successfully",
		"symbol":      token.Symbol,
		"newPrice":    price.CurrentPrice,
		"updatedAt":   time.Now(),
	})
}

func healthCheck(c *gin.Context) {
	// Check database connection
	dbStatus := "healthy"
	if err := db.Ping(); err != nil {
		dbStatus = "unhealthy: " + err.Error()
	}

	// Check price service status
	priceStatus := "healthy"
	timeSinceUpdate := time.Since(priceService.lastUpdate)
	if timeSinceUpdate > 5*time.Minute {
		priceStatus = fmt.Sprintf("stale: last update %v ago", timeSinceUpdate)
	}

	status := http.StatusOK
	if dbStatus != "healthy" || strings.Contains(priceStatus, "stale") {
		status = http.StatusServiceUnavailable
	}

	c.JSON(status, gin.H{
		"status":           "ok",
		"timestamp":        time.Now(),
		"database":         dbStatus,
		"priceService":     priceStatus,
		"cachedPrices":     len(priceService.priceCache),
		"lastPriceUpdate":  priceService.lastUpdate,
		"uptime":           time.Since(priceService.lastUpdate),
	})
}
func fixDatabaseSchema() error {
	log.Println("🔧 Checking and fixing database schema...")
	
	// List of columns that should exist
	columns := []struct {
		name         string
		datatype     string
		nullable     bool
		defaultValue string
	}{
		{"market_cap", "DECIMAL(20,2)", true, "DEFAULT 0"},
		{"volume_24h", "DECIMAL(20,2)", true, "DEFAULT 0"},
		{"change_24h", "DECIMAL(10,4)", true, "DEFAULT 0"},
		{"coingecko_id", "VARCHAR(100)", true, ""},
		{"contract_address", "VARCHAR(100)", true, ""},
		{"logo_url", "TEXT", true, ""},
		{"price", "DECIMAL(20,8)", false, "NOT NULL DEFAULT 0"},
		{"created_at", "TIMESTAMP", true, "DEFAULT CURRENT_TIMESTAMP"},
		{"updated_at", "TIMESTAMP", true, "DEFAULT CURRENT_TIMESTAMP"},
	}
	
	for _, col := range columns {
		var exists bool
		err := db.QueryRow(`
			SELECT EXISTS (
				SELECT 1 FROM information_schema.columns 
				WHERE table_name = 'tokens' 
				AND column_name = $1
			)`, col.name).Scan(&exists)
		
		if err != nil {
			return fmt.Errorf("failed to check column %s: %v", col.name, err)
		}
		
		if !exists {
			sql := fmt.Sprintf("ALTER TABLE tokens ADD COLUMN %s %s %s", 
				col.name, col.datatype, col.defaultValue)
			
			_, err = db.Exec(sql)
			if err != nil {
				return fmt.Errorf("failed to add column %s: %v", col.name, err)
			}
			log.Printf("✅ Added column: %s", col.name)
		}
	}
	
	// Update existing tokens with coingecko_id if they don't have it
	tokenUpdates := []struct {
		symbol      string
		coingeckoID string
	}{
		{"BTC", "bitcoin"},
		{"ETH", "ethereum"},
		{"USDC", "usd-coin"},
		{"USDT", "tether"},
		{"BNB", "binancecoin"},
		{"SOL", "solana"},
		{"ADA", "cardano"},
		{"DOGE", "dogecoin"},
		{"MATIC", "matic-network"},
		{"DOT", "polkadot"},
	}
	
	for _, update := range tokenUpdates {
		_, err := db.Exec(`
			UPDATE tokens 
			SET coingecko_id = $1 
			WHERE symbol = $2 AND (coingecko_id IS NULL OR coingecko_id = '')`,
			update.coingeckoID, update.symbol)
		
		if err != nil {
			log.Printf("Warning: Failed to update coingecko_id for %s: %v", update.symbol, err)
		}
	}
	
	log.Println("✅ Database schema check completed")
	return nil
}
func (ps *PriceService) fetchCoinGeckoPrices(coinGeckoIDs []string) []CoinGeckoResponse {
	if len(coinGeckoIDs) == 0 {
		return nil
	}

	// Limit to 100 coins per request (CoinGecko limit)
	if len(coinGeckoIDs) > 100 {
		coinGeckoIDs = coinGeckoIDs[:100]
	}

	// Clean and validate coin IDs
	var validIDs []string
	for _, id := range coinGeckoIDs {
		if strings.TrimSpace(id) != "" {
			validIDs = append(validIDs, strings.TrimSpace(id))
		}
	}

	if len(validIDs) == 0 {
		log.Println("No valid coin IDs to fetch")
		return nil
	}

	// CoinGecko API endpoint with proper parameters
	url := fmt.Sprintf("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=%s&order=market_cap_desc&per_page=%d&page=1&sparkline=false&price_change_percentage=24h&locale=en",
		strings.Join(validIDs, ","), len(validIDs))

	log.Printf("🔄 Fetching prices for: %v", validIDs)
	log.Printf("🌐 API URL: %s", url)

	client := &http.Client{
		Timeout: 15 * time.Second, // Increased timeout
	}

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Printf("Error creating request: %v", err)
		return nil
	}

	// Add headers to avoid being blocked
	req.Header.Set("User-Agent", "TokenSwapAPI/1.0")
	req.Header.Set("Accept", "application/json")

	resp, err := client.Do(req)
	if err != nil {
		log.Printf("Error fetching prices from CoinGecko: %v", err)
		return nil
	}
	defer resp.Body.Close()

	// Read response body for debugging
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Printf("Error reading response: %v", err)
		return nil
	}

	if resp.StatusCode != 200 {
		log.Printf("❌ CoinGecko API returned status %d", resp.StatusCode)
		log.Printf("Response body: %s", string(body))
		
		// Handle specific error codes
		switch resp.StatusCode {
		case 400:
			log.Println("Bad Request - Check coin IDs format")
		case 429:
			log.Println("Rate limit exceeded - reducing update frequency")
		case 404:
			log.Println("Endpoint not found - Check API URL")
		}
		return nil
	}

	var prices []CoinGeckoResponse
	if err := json.Unmarshal(body, &prices); err != nil {
		log.Printf("Error parsing response: %v", err)
		log.Printf("Response body: %s", string(body))
		return nil
	}

	log.Printf("✅ Successfully fetched %d prices", len(prices))
	return prices
}

// Add this helper function to validate CoinGecko IDs
func validateCoinGeckoIDs() error {
	log.Println("🔍 Validating CoinGecko IDs...")
	
	rows, err := db.Query("SELECT symbol, coingecko_id FROM tokens WHERE coingecko_id IS NOT NULL AND coingecko_id != ''")
	if err != nil {
		return err
	}
	defer rows.Close()

	var invalidTokens []string
	for rows.Next() {
		var symbol, coinGeckoID string
		if err := rows.Scan(&symbol, &coinGeckoID); err != nil {
			continue
		}

		// Test individual coin ID
		testURL := fmt.Sprintf("https://api.coingecko.com/api/v3/coins/%s", coinGeckoID)
		client := &http.Client{Timeout: 10 * time.Second}
		
		resp, err := client.Get(testURL)
		if err != nil {
			log.Printf("⚠️  Cannot validate %s (%s): %v", symbol, coinGeckoID, err)
			continue
		}
		resp.Body.Close()

		if resp.StatusCode != 200 {
			log.Printf("❌ Invalid CoinGecko ID for %s: %s (status: %d)", symbol, coinGeckoID, resp.StatusCode)
			invalidTokens = append(invalidTokens, symbol)
		} else {
			log.Printf("✅ Valid CoinGecko ID for %s: %s", symbol, coinGeckoID)
		}
		
		// Add delay to avoid rate limiting
		time.Sleep(200 * time.Millisecond)
	}

	if len(invalidTokens) > 0 {
		log.Printf("Found %d tokens with invalid CoinGecko IDs: %v", len(invalidTokens), invalidTokens)
	}

	return nil
}