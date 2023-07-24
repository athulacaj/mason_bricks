import '../functions/localize_functions.dart';
import 'app.dart';
import 'models/req_model.dart';
import 'models/res_model.dart';

// to test
// void main() async {
//   await runServer(localizeFunctions: null);
// }

Future<void> runServer({required LocalizeFunctions localizeFunctions}) async {
  const port = 8000;

  App app = App();
  app.get("/getAllData", (Req req, Res res) {
    res.send(localizeFunctions.getTableData);
  });
  app.get("/getTableData", (Req req, Res res) {
    res.send(localizeFunctions.getTableData());
  });

  app.get("/getMissingTableData", (Req req, Res res) {
    res.send(localizeFunctions.getMissingKeysTableData());
  });

  app.get("/getAllKeys", (Req req, Res res) {
    res.send(localizeFunctions.allKeys);
  });

  app.get("/getAllInfo", (Req req, Res res) {
    res.send({
      "allKeys": localizeFunctions.allKeys,
      "defaultLocale": localizeFunctions.configeModel.defaultLocale,
      "langs": localizeFunctions.configeModel.locales,
    });
  });

  app.post("/addLabel", (req, res) {
    Map data = req.body;
    if (data['key'] != null && data['value'] != null) {
      if (!(data['value'] is Map)) {
        return res.send({"message": "value must be a map"});
      }
    }
    print(data['value']);
    localizeFunctions.createLabel(data["key"], data["value"]);
    res.send({"message": "data added"});
  });

  await app.listen(
    port,
    () => {
      print("listening on port $port"),
    },
  );
}
