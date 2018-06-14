function loadJSON(callback) {

    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    xobj.open('GET', 'assets/json/refs.json', true);
    xobj.onreadystatechange = function() {
        if (xobj.readyState == 4 && xobj.status == "200") {

            // .open will NOT return a value but simply returns undefined in async mode so use a callback
            callback(xobj.responseText);

        }
    }
    xobj.send(null);

}

// Call to function with anonymous callback
loadJSON(function(response) {
    // Do Something with the response e.g.
    jsonresponse = JSON.parse(response);

    // Assuming json data is wrapped in square brackets as Drew suggests
    //console.log(jsonresponse);

    for (var item in jsonresponse) {
       var service = item;
       var url = jsonresponse[item];

       $('.table-body-urls').append('<tr><td>' + service + '</td><td><a href="' + url + '">' + url + '</a></td></tr>'); // Sin TAB
       //$('.table-body-urls').append('<tr><td><span class="tab">' + service + '</span></td><td><span class="tab"><a href="' + url + '">' + url + '</a></span></td></tr>'); // Con TAB
    }
});
