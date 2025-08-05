import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/store_model.dart';

abstract class StoreRemoteDataSource {
  Future<StoreModel> getStoreById(String storeId);
  Future<List<StoreModel>> getStoresByCategory(String categoryId);
  Future<List<StoreModel>> searchStores(String query);
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final ApiClient _apiClient;

  StoreRemoteDataSourceImpl(this._apiClient);

  @override
  Future<StoreModel> getStoreById(String storeId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>('/stores/$storeId');

      if (response.data == null) {
        throw ApiException('No se recibieron datos del local', response.statusCode);
      }

      final storeApi = StoreApiModel.fromJson(response.data!);
      
      return StoreModel(
        id: storeApi.id,
        name: storeApi.name,
        description: storeApi.description,
        address: storeApi.address,
        phone: storeApi.phone,
        email: storeApi.email,
        whatsapp: storeApi.whatsapp,
        website: storeApi.website,
        latitude: storeApi.latitude,
        longitude: storeApi.longitude,
        images: storeApi.images,
        hours: _convertStoreHours(storeApi.hours),
        isActive: storeApi.isActive,
        categories: storeApi.categories,
        createdAt: storeApi.createdAt,
        updatedAt: storeApi.updatedAt,
      );
    } catch (e) {
      throw ApiException('Error al obtener información del local: ${e.toString()}', null);
    }
  }

  @override
  Future<List<StoreModel>> getStoresByCategory(String categoryId) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/stores',
        queryParameters: {'categoryId': categoryId},
      );

      if (response.data == null) {
        throw ApiException('No se recibieron datos de locales', response.statusCode);
      }

      final storesResponse = StoresResponse.fromJson(response.data!);
      
      return storesResponse.stores.map((storeApi) {
        return StoreModel(
          id: storeApi.id,
          name: storeApi.name,
          description: storeApi.description,
          address: storeApi.address,
          phone: storeApi.phone,
          email: storeApi.email,
          whatsapp: storeApi.whatsapp,
          website: storeApi.website,
          latitude: storeApi.latitude,
          longitude: storeApi.longitude,
          images: storeApi.images,
          hours: _convertStoreHours(storeApi.hours),
          isActive: storeApi.isActive,
          categories: storeApi.categories,
          createdAt: storeApi.createdAt,
          updatedAt: storeApi.updatedAt,
        );
      }).toList();
    } catch (e) {
      throw ApiException('Error al obtener locales: ${e.toString()}', null);
    }
  }

  @override
  Future<List<StoreModel>> searchStores(String query) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/stores/search',
        queryParameters: {'q': query},
      );

      if (response.data == null) {
        throw ApiException('No se recibieron resultados de búsqueda', response.statusCode);
      }

      final storesResponse = StoresResponse.fromJson(response.data!);
      
      return storesResponse.stores.map((storeApi) {
        return StoreModel(
          id: storeApi.id,
          name: storeApi.name,
          description: storeApi.description,
          address: storeApi.address,
          phone: storeApi.phone,
          email: storeApi.email,
          whatsapp: storeApi.whatsapp,
          website: storeApi.website,
          latitude: storeApi.latitude,
          longitude: storeApi.longitude,
          images: storeApi.images,
          hours: _convertStoreHours(storeApi.hours),
          isActive: storeApi.isActive,
          categories: storeApi.categories,
          createdAt: storeApi.createdAt,
          updatedAt: storeApi.updatedAt,
        );
      }).toList();
    } catch (e) {
      throw ApiException('Error en la búsqueda de locales: ${e.toString()}', null);
    }
  }

  // Convertir StoreHoursApiModel a StoreHours
  StoreHours _convertStoreHours(StoreHoursApiModel apiHours) {
    final schedules = <DayOfWeek, DaySchedule>{};
    
    apiHours.schedules.forEach((key, value) {
      final dayOfWeek = _parseDayOfWeek(key);
      schedules[dayOfWeek] = DaySchedule(
        isOpen: value.isOpen,
        openTime: value.openTime,
        closeTime: value.closeTime,
        breakStart: value.breakStart,
        breakEnd: value.breakEnd,
      );
    });

    return StoreHours(
      schedules: schedules,
      specialHours: apiHours.specialHours,
      isOpenNow: apiHours.isOpenNow,
    );
  }

  // Parsear string a DayOfWeek enum
  DayOfWeek _parseDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DayOfWeek.monday;
      case 'tuesday':
        return DayOfWeek.tuesday;
      case 'wednesday':
        return DayOfWeek.wednesday;
      case 'thursday':
        return DayOfWeek.thursday;
      case 'friday':
        return DayOfWeek.friday;
      case 'saturday':
        return DayOfWeek.saturday;
      case 'sunday':
        return DayOfWeek.sunday;
      default:
        return DayOfWeek.monday;
    }
  }
} 