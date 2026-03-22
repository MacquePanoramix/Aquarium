// A single element in a rotational mass-spring-damper system.
class MSDS {
  float mass, force, angularAcceleration, angularVelocity, angle;
  float damping, springConstant, restingAngle;

  MSDS(float mass, float springConstant, float damping, float restingAngle) {
    this.mass = mass;
    this.damping = damping;
    this.springConstant = springConstant;
    this.restingAngle = restingAngle;
    this.angle = restingAngle;
    this.force = 0;
    this.angularVelocity = 0;
    this.angularAcceleration = 0;
  }

  void update(float previousVelocity, float nextForce) {
    angularVelocity += (nextForce - force) / mass;
    float velocity = angularVelocity;
    angle += velocity - previousVelocity;
    force = (angle - restingAngle) * springConstant + (velocity - previousVelocity) * damping;
  }
}
