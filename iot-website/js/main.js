$(function() {
    scan_ssid();


    var form = document.querySelector("form");
    form.onsubmit = submitted.bind(form);

    $("#show_hide_password a").on('click', function(event) {
        event.preventDefault();
        if($('#show_hide_password input').attr("type") == "text"){
            $('#show_hide_password input').attr('type', 'password');
            $('#show_hide_password i').addClass( "fa-eye-slash" );
            $('#show_hide_password i').removeClass( "fa-eye" );
        }else if($('#show_hide_password input').attr("type") == "password"){
            $('#show_hide_password input').attr('type', 'text');
            $('#show_hide_password i').removeClass( "fa-eye-slash" );
            $('#show_hide_password i').addClass( "fa-eye" );
        }
    });

    $("#sucess").hide();
    $("#error").hide();
    $("#error-critical").hide();
});



function scan_ssid(){
    var xmlhttp = new XMLHttpRequest();
    var url = "http://192.168.27.1:8080/scan";
   
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var myArr = JSON.parse(this.responseText);
            myFunction(myArr);
        }
    };
    xmlhttp.open("GET", url, true);
    xmlhttp.send();
    
    function myFunction(arr) {
        $('#ssid').empty();
        var i;
        options = arr.payload;
        $.each(options, function(i, p) {
            $('#ssid').append($('<option></option>').val(p.ssid).html(p.ssid));
        });

        //document.getElementById("id01").innerHTML = out;
    }

    xmlhttp.onerror = function(error) {
        $("#error-critical").show();
    }
}

function submitted(event) {
    event.preventDefault();

    ssid = document.getElementById('ssid').value;
    password = document.getElementById('password').value;

    $("#sucess").show();
  
    var xhr = new XMLHttpRequest();
    var url = "http://192.168.27.1:8080/connect";
    
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            var json = JSON.parse(xhr.responseText);   
            status = json.status;
            if(status == "OK")
                $("#sucess").show();
            else
                $("#error").show();
        }
    };
    var data = JSON.stringify({"ssid": ssid, "psk": password});
    xhr.send(data);

    xhr.onerror = function(error) {
        $("#error-critical").show();
    }

}