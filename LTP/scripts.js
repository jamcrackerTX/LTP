$(document).ready(function () {
    GetPeople("");
    GetStates();
    $('.show-add').click(function () {
        $('#AddPersonContainer').removeClass('hidden');
    });
    
    $('#addPersonButton').click(function (e) {
        e.preventDefault();
        var f = $('#InputFirstName').val();
        var l = $('#InputLastName').val();
        var g = $('#SelectGender').val();
        var s = $('#SelectState').val();
        var m = $('#SelectMonth').val();
        var d = $('#SelectDay').val();
        var y = $('#SelectYear').val();
        var dob = y + '-' + m + '-' + d;
        var hasError = false;

        if (f.length < 1) {
            hasError = true;
            alert("First Name is required.");
        }
        if (l.length < 1) {
            hasError = true;
            alert("Last Name is required.");
        }
        if (g === "0") {
            hasError = true;
            alert("Select a gender.");
        }
        if (s === "0") {
            hasError = true;
            alert("Select a state.");
        }
        
        if (dob.length  < 10) {
            hasError = true;
            alert("Enter a valid date of birth.");
        }
        if (!hasError) {
            var p = {
                Id: "",
                FirstName: f,
                LastName: l,
                StateId: s,
                Gender: g,
                DOB: dob
            };
            AddPerson(p);
        }


            
    });

    $('#editPersonButton').click(function (e) {
        e.preventDefault();
        var id = $('#personId').val();
        var f = $('#mInputFirstName').val();
        var l = $('#mInputLastName').val();
        var g = $('#mSelectGender').val();
        var s = $('#mSelectState').val();
        var m = $('#mSelectMonth').val();
        var d = $('#mSelectDay').val();
        var y = $('#mSelectYear').val();
        var dob = y + '-' + m + '-' + d;
        var hasError = false;

        if (f.length < 1) {
            hasError = true;
            alert("First Name is required.");
        }
        if (l.length < 1) {
            hasError = true;
            alert("Last Name is required.");
        }
        if (g === "0") {
            hasError = true;
            alert("Select a gender.");
        }
        if (s === "0") {
            hasError = true;
            alert("Select a state.");
        }

        if (dob.length < 10) {
            hasError = true;
            alert("Enter a valid date of birth.");
        }
        if (!hasError) {
            var p = {
                Id: id,
                FirstName: f,
                LastName: l,
                StateId: s,
                Gender: g,
                DOB: dob
            };
            $('#editModal').modal('hide');
            AddPerson(p);
        }
    });
    $(".searchPerson").keyup(function () {
        var search = $(".searchPerson").val().toLowerCase();

        if (search.length > 0) {

            $('#peopleTable > tbody > tr').each(function () {

                var f = $(this).find("td:eq(0)").text().toLowerCase();
                var l = $(this).find("td:eq(1)").text().toLowerCase();

                if (l.indexOf(search) === -1 && f.indexOf(search) === -1) {
                    $(this).fadeOut();
                }
            });
        } else {
            GetPeople("");
        }
    });

    $(".page-nav__list").click(function () {
        console.log("clicked");
        $("#staff-page-search-input").val("");
        $("#staff-page-filter").fadeOut();
        $('#staff-page-directory').fadeIn();
    });
});

function EditPerson(id) {
    $('#editModal').modal('show');

    var row = $("#person-"+id).closest("tr");
    console.log(row);
    var p = new Object();

    p.id = id;
    p.f = row.find('td:eq(0)').text();
    p.l = row.find('td:eq(1)').text();
    p.s = row.find('td:eq(2)').text();
    p.g = row.find('td:eq(3)').text();
    p.dob = row.find('td:eq(4)').text();

    
    var d = p.dob.substring(0, 10).split("-");

    //console.log(p);

    $('#mInputFirstName').val(p.f);
    $('#mInputLastName').val(p.l);
    $('#mSelectGender option[value='+p.g+'').attr('selected','selected');
    $('#mSelectState option[value="' + p.s + '"').attr('selected', 'selected');
    $('#mSelectMonth option[value="' + d[1] + '"').attr('selected', 'selected');
    $('#mSelectDay option[value="' + d[2] + '"').attr('selected', 'selected');
    $('#mSelectYear option[value="' + d[0] + '"').attr('selected', 'selected');
    $('#personId').val(p.id);
}


function GetPeople(s) {
    $.ajax({
        url: "/Services/GetPeople.ashx?s=" + s,
        dataType: 'JSON',
        success: function (data) {
            if (data.length !== 0) {
                $('#peopleTable > tbody').empty();
                var output = "";
                for (var i in data) {
                    output += "<tr><td>" +
                        data[i].FirstName +
                        "</td><td>" +
                        data[i].LastName +
                        "</td><td>" +
                        data[i].StateId +
                        "</td><td>" +
                        data[i].Gender +
                        "</td><td>" +
                        data[i].DOB +
                        "</td><td>" +
                        //<a onclick="jsfunction()" href="javascript:void(0);">
                        "<a onclick=\"EditPerson("+data[i].Id+")\" href=\"javascript:void(0);\" id=\"person-"+data[i].Id+"\" class=\"edit-person btn btn-default\">Edit</button></td></tr>";
                }
                $('#peopleTable > tbody').append(output);
                $('#peopleTable').removeClass("hidden");
            }
        },
        error: function (data, status, jqXHR) { console.log("People-FAILED:" + status); }
    }); 
}

function GetStates(s) {
    $.ajax({
        url: "/Services/GetStates.ashx",
        dataType: 'JSON',
        success: function (data) {
            if (data.length !== 0) {
                var output = "";
                for (var i in data) {
                    output += "<option value=\"" +
                        data[i].Id +
                        "\">" +
                        data[i].Code +
                        "</option>";
                }
                //console.log(output);
                $(output).appendTo('#SelectState');
                $(output).appendTo('#mSelectState');            }
        },
        error: function (data, status, jqXHR) { console.log("States-FAILED:" + status); }
    });
}

function AddPerson(p) {
    var data = JSON.stringify(p);
    //console.log(data);
    $.ajax({
        type: "POST",
        url: "/Services/UpsertPerson.ashx",
        data: data,
        dataType: "JSON",
        success: function (data) {
            //console.log(data);
            GetPeople("");
            $('#AddPersonContainer').addClass('hidden');
            $('form').trigger("reset");
        },
        error: function (data) {
            console.log(data);
        }

    });
   
}