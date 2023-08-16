class WeatherModel {
  final String temp;
  final String tempMin;
  final String tempMax;
  final String city;
  final String desc;
  final double windSpeed;

  WeatherModel.fromMap(Map<String, dynamic> json)
      : temp = json['main']['temp'].toString(),
        tempMin = json['main']['temp_min'].toString(),
        tempMax = json['main']['temp_max'].toString(),
        city = json['name'],
        desc = json['weather'][0]['description'],
        windSpeed =
            double.parse(json['wind']['speed'].toString()); // Add wind speed
}
