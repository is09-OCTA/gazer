/**
 * @method getXYZ 座標変換
 * @param {object} location
  * @param {double} altitude 高度
  * @param {double} direction 方位  
 */
const getXYZ = (location) => {
  // 座標
  let coordinate = {
    x: 0,
    y: 0,
    z: 0
  }

  let theta = (90 - location.altitude) * (PI / 180);
  let phi = location.direction * (PI / 180);
  let r = 10;

  coordinate.z = r * Math.sin(theta) * Math.cos(phi);
  coordinate.x = r * Math.sin(theta) * Math.sin(phi);
  coordinate.y = r * Math.cos(theta);

  return coordinate;
}