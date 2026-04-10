import 'package:flutter/foundation.dart';

import '../models/election.dart';
import '../models/election_create_request.dart';
import '../../../core/network/api_service.dart';

/// Provider for managing election-related state and operations
class ElectionProvider with ChangeNotifier {
  final ApiService _apiService;
  
  List<Election> _elections = [];
  Election? _currentElection;
  bool _isLoading = false;
  String? _error;

  ElectionProvider(this._apiService);

  // Getters
  List<Election> get elections => _elections;
  Election? get currentElection => _currentElection;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Create a new election
  Future<bool> createElection(ElectionCreateRequest request) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.post('/elections', data: request.toJson());
      
      if (response.statusCode == 201) {
        final election = Election.fromJson(response.data);
        _elections.add(election);
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _setError('Failed to create election: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch all elections
  Future<void> fetchElections() async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.get('/elections');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _elections = data.map((json) => Election.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to fetch elections: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch election by ID
  Future<Election?> fetchElectionById(String id) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.get('/elections/$id');
      
      if (response.statusCode == 200) {
        final election = Election.fromJson(response.data);
        _currentElection = election;
        notifyListeners();
        return election;
      }
      
      return null;
    } catch (e) {
      _setError('Failed to fetch election: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an election
  Future<bool> updateElection(String id, ElectionCreateRequest request) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.put('/elections/$id', data: request.toJson());
      
      if (response.statusCode == 200) {
        final updatedElection = Election.fromJson(response.data);
        final index = _elections.indexWhere((e) => e.id == id);
        if (index != -1) {
          _elections[index] = updatedElection;
        }
        
        if (_currentElection?.id == id) {
          _currentElection = updatedElection;
        }
        
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _setError('Failed to update election: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete an election
  Future<bool> deleteElection(String id) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _apiService.delete('/elections/$id');
      
      if (response.statusCode == 200) {
        _elections.removeWhere((e) => e.id == id);
        
        if (_currentElection?.id == id) {
          _currentElection = null;
        }
        
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _setError('Failed to delete election: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get active elections
  List<Election> get activeElections {
    final now = DateTime.now();
    return _elections.where((election) {
      return election.startDate.isBefore(now) && election.endDate.isAfter(now);
    }).toList();
  }

  /// Get upcoming elections
  List<Election> get upcomingElections {
    final now = DateTime.now();
    return _elections.where((election) {
      return election.startDate.isAfter(now);
    }).toList();
  }

  /// Get past elections
  List<Election> get pastElections {
    final now = DateTime.now();
    return _elections.where((election) {
      return election.endDate.isBefore(now);
    }).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  /// Clear all data
  void clear() {
    _elections.clear();
    _currentElection = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}