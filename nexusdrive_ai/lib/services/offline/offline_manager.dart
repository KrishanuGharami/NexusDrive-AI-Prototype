class OfflineCacheSummary {
  final int cachedRoutesCount;
  final int cachedStationsCount;
  final int cachedDeadzonePolygons;
  final bool isOfflineReady;
  final String storageFormat;

  const OfflineCacheSummary({
    required this.cachedRoutesCount,
    required this.cachedStationsCount,
    required this.cachedDeadzonePolygons,
    required this.isOfflineReady,
    required this.storageFormat,
  });
}

class OfflineManager {
  OfflineCacheSummary getCacheStatus() {
    return const OfflineCacheSummary(
      cachedRoutesCount: 9,
      cachedStationsCount: 8,
      cachedDeadzonePolygons: 6,
      isOfflineReady: true,
      storageFormat: 'Local Embedded JSON + In-Memory Vector Index',
    );
  }
}
