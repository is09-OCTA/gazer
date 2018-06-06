/**
 * @method calcMJD 修正ユリウス日(MJD)への計算
 * @param {int} yyyy  年
 * @param {int} MM    月
 * @param {int} dd    日
 */
const calcMJD = (yyyy, MM, dd) => {
  let y;
  let m;

  if (MM <= 2) { 
    y = yyyy - 1;
    m = MM + 12;
  } else {
    y = yyyy;
    m = MM;
  }

  let ret = Math.floor(365.25 * y) + Math.floor(y / 400) - Math.floor(y / 100);
  ret = ret + Math.floor(30.59 * (m - 2)) + dd - 678912;

  return ret;
}