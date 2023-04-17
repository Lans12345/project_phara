double calculateTravelTimeInMinutes(double distance, double speed) {
  double travelTimeInSeconds = calculateTravelTime(distance, speed);
  return travelTimeInSeconds / 60.0;
}

double calculateTravelTime(double distance, double speed) {
  return distance / speed;
}
