var noctambusL = ["NA", "NC", "ND", "NE", "NJ", "NK", "NM", "NO", "NP", "NS", "NT", "NV"];

$(document).on('pageinit', '#HomePage', function () {
    Parse.initialize("qTbnMxAZlnJjixfNs1gdkKjSEMUqyfzR2QgY4CPc", "wQRPkRwajw5a7egoCnyeF5BMymweg9gJh5ySDyUT");
    $("#progressbar").progressbar({ value: 0 });
    $("#progressbar2").progressbar({ value: 0 });
});

function startC() {
    callGetStopsTPG();
}

function startP(){
    callGetPhysicalStopsTPG();
}

function callGetStopsTPG() {
    $.ajax({
        url: 'https://crossorigin.me/http://prod.ivtr-od.tpg.ch/v1/GetStops.json?key=5f4382a0-fc2b-11e3-b5a1-0002a5d5c51b',
        cache: false,
        success: function (result) {
            ajax.parseJSON(result);
        },
        error: function (request, error) {
            alert('Network error has occurred please try again!');
        }
    });
}

function callGetPhysicalStopsTPG() {
    $.ajax({
        url: 'https://crossorigin.me/http://prod.ivtr-od.tpg.ch/v1/GetPhysicalStops.json?key=5f4382a0-fc2b-11e3-b5a1-0002a5d5c51b',
        cache: false,
        success: function (result) {
            ajax2.parseJSON(result);
        },
        error: function (request, error) {
            alert('Network error has occurred please try again!');
        }
    });
}

var ajax = {
    parseJSON: function (result) {
        var Arrets = Parse.Object.extend("Arrets");
        var i = 0;
        $("#progressbar").progressbar({ max: result.stops.length });

        $.each(result.stops, function (i, row) {
            //console.log(result.stops.length);
            var arrayNoctambus = new Set();
            $.each(row.connections, function (i, row) {
                //console.log(row.lineCode);
                if ($.inArray(row.lineCode, noctambusL) != -1) {
                    //console.log(row.lineCode);
                    arrayNoctambus.add(row.lineCode);
                }

            });

            if (arrayNoctambus.size > 0) {
                var arret = new Arrets();
                arret.set("codeArret", row.stopCode);
                arret.set("nomArret", row.stopName);
                var myArr = Array.from(arrayNoctambus);
                arret.set("ligneArret", myArr);

                arret.save(null, {
                    success: function (arret) {
                        $(".success").show();
                    },
                    error: function (arret, error) {
                        $(".error").show();
                    }
                });

            }

            i++;
            $("#progressbar").progressbar({ value: i });
        });
    }
}

var ajax2 = {
    parseJSON: function (result) {
        var ArretsPhy = Parse.Object.extend("ArretsPhysique");
        var i = 0;
        $("#progressbar2").progressbar({ max: result.stops.length });

        $.each(result.stops, function (i, row) {
            var stopCode = row.stopCode;
            $.each(row.physicalStops, function (i, row) {
                //Construction du tableau d'objet pour l'arret physique
                var arrayPhy = [];
                $.each(row.connections, function (i, row) {
                    if ($.inArray(row.lineCode, noctambusL) != -1) {
                        arrayPhy.push({
                            lineCode: row.lineCode,
                            destinationName: row.destinationName
                        });
                    }
                });

                if (arrayPhy.length > 0) {

                    var geo = new Parse.GeoPoint(row.coordinates.latitude, row.coordinates.longitude);
                    var arretsPhy = new ArretsPhy();
                    arretsPhy.set("CodeArrectC", stopCode);
                    arretsPhy.set("CodeArretPhysique", row.physicalStopCode);
                    arretsPhy.set("nomArretP", row.stopName);
                    arretsPhy.set("Lignes", arrayPhy);
                    arretsPhy.set("Coordonnees", geo);

                    arretsPhy.save(null, {
                        success: function (arretsPhy) {
                            $(".success").show();
                        },
                        error: function (arretsPhy, error) {
                            $(".error").show();
                        }
                    });

                }

            });
			i++;
            $("#progressbar2").progressbar({ value: i });

        });
    }}

