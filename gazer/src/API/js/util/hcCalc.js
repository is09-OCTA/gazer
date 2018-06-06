/** 
 * @method hcCalc 方位、高度の計算
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
const hcCalc = (date, area, PI, RAD) => {
  let mjd = calcMJD(date.yyyy, date.MM, date.dd) 
            + date.HH / 24 + date.mm / 1440 + date.ss / 86400 - 0.375;
  let d = (0.671262 + 1.002737909 * (mjd - 40000) + area.longitude / 360);
  let lst = 2 * PI * (d - Math.floor(d));

  let slat = Math.sin(area.latitude / RAD);
  let clat = Math.cos(area.latitude / RAD);
  let ra = 15 * area.alfa / RAD;
  let dc = area.delta / RAD;
  let ha = lst - ra;
  let sdc = Math.sin(dc);
  let cdc = Math.cos(dc);
  let sha = Math.sin(ha);
  let cha = Math.cos(ha);
  let xs = sdc * slat + cdc * clat * cha;
  let h  = Math.asin(xs);
  let s = cdc * sha;
  let c = cdc * slat * cha - sdc * clat;
  let a;

  if (c < 0) {
    a = Math.atan(s / c) + PI;
  } else if (c > 0 && s <= 0) {
    a = Math.atan(s / c) + 2 * PI;
  } else {
    a = Math.atan(s / c);
  }
  if (h == 0) {
    h = 0.00001;
  }
  a = a * RAD;
  h = h * RAD;
  let rt = Math.tan((h + 8.6 / (h + 4.4)) / RAD);       // 大気補正
  h  = h + 0.0167 / rt;
  let sa = "" + a;
  let sh = "" + h;

  let starLocation = {
    direction: sa.substring(0,7),
    altitude: sh.substring(0,6)
  }
  
  return starLocation;
}