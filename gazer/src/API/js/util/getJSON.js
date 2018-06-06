/**
 * @method getJSON JSON 形式のデータを取得
 */
const getJSON = () => {
  let req = new XMLHttpRequest();
  req.open("GET", "./json/db.json", false);
  req.send(null);
  let data = JSON.parse(req.responseText);

  return data;

  // TEST
  for (i = 0; i < data.stars.length; i++) {
    console.log(data.stars[i].hipId);
    console.log(data.stars[i].enName);
    console.log(data.stars[i].rightAscension);
    console.log(data.stars[i].declination);
    console.log(data.stars[i].magnitude);
  }
}