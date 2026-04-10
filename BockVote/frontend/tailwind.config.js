/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f9f5fa',
          100: '#f3ebf4',
          200: '#e6d7e9',
          300: '#d4b6d8',
          400: '#c095c3',
          500: '#ac77ac',
          600: '#924c92',
          700: '#7a3f7a',
          800: '#653565',
          900: '#542c54',
        },
      },
    },
  },
  plugins: [],
}; 