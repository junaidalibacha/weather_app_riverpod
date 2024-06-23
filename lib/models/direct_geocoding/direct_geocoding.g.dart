// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direct_geocoding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DirectGeocodingImpl _$$DirectGeocodingImplFromJson(
        Map<String, dynamic> json) =>
    _$DirectGeocodingImpl(
      name: json['name'] as String? ?? "",
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      country: json['country'] as String? ?? "",
    );

Map<String, dynamic> _$$DirectGeocodingImplToJson(
        _$DirectGeocodingImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'country': instance.country,
    };
