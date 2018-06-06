/**
 * @method getStarLocation 
 * @param {object} date 観測日時  
  * @param {int} yyyy 年
  * @param {int} MM   月
  * @param {int} dd   日
  * @param {int} HH   時
  * @param {int} mm   分
  * @param {int} ss   秒
 * 
 * @param {object} area 観測地点 
  * @param {double} latitude    緯度
  * @param {double} longitude   経度
  * @param {double} alfa        赤経
  * @param {double} delta       赤緯 
 */
const getStarInfo = (date, area) => {
  let data = getJSON();

  // test
  console.log(data);  

  let starsLocation = [];
  let starsXYZ = [];
  let starsMagnitude = [];

  for (let i = 0; i < data.stars.length; i++) {
    area.alfa = data.stars[i].rightAscension;
    area.delta = data.stars[i].declination;

    // [高度, 方位]
    starsLocation[i] = hcCalc(date, area, PI, RAD);
    starsXYZ[i] = getXYZ(starsLocation[i]);

    // 等級
    starsMagnitude[i] = data.stars[i].magnitude;
  }

  // test
  // console.log(starsLocation);
  console.log(starsMagnitude);
  console.log(starsXYZ);
  

  return (starsXYZ, starsMagnitude);
}