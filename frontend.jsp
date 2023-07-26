<%-- 
    Document   : frontend
    Created on : Jul 10, 2023, 4:04:21 PM
    Author     : it.trainee
--%>
<!DOCTYPE html>
<html>
    <head>
        <title>High Tension Meter Application Bill Details</title>

        <link rel="stylesheet" href="css/bootstrap.min.css">
        <script src="js/jquery.slim.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <link href="css/font_family.css" rel="stylesheet">

        <!-- Custom styles for this template-->
        <link href="css/sb-admin-2.min.css" rel="stylesheet">
        <script src="js/jquery.min.js"></script>
        <link href="css/jquery.dataTables.min.css" rel="stylesheet">
        <script src="js/jquery.dataTables.min.js"></script>
        <script src="js/bootstrap.min.js"></script>


        <style>
    body {
        padding: 20px;
    }

    .container {
        max-width: 1000px;
        margin: 0 auto;
    }

    h1 {
        text-align: center;
        margin-bottom: 20px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .error-message {
        color: red;
        margin-top: 10px;
    }

    .details {
        margin-top: 20px;
        background-color: #f8f9fa;
        padding: 10px;
    }
        </style>
        <script>
            function validateMRNumber() {
                var mrNumber = $("#mrNumber").val();
                var regex = /^\d{10}$/; // Regex to match exactly 10 digits

                if (regex.test(mrNumber)) {
                    submitMRNumber();
                } else {
                    alert("Please Enter A Valid 10 Digit MR Number!!");
                }
            }


            function submitMRNumber() {
                var mrNumber = $("#mrNumber").val();
               
                $.ajax({
                    type: 'GET',
                    url: 'backend.jsp',
                    dataType: 'json',
                    //async:false,
                    data: {
                        "req_type": 'REQ',
                        "mrNumber": mrNumber
                    },
                    success: function (response) {


                        $("#stattablediv").show();
                        $('#stattblbody').empty();
                        $("#submitMR").attr("disabled", true);
                        $('#data-table').dataTable().fnClearTable();
                        $('#data-table').dataTable().fnDestroy();
                        var myObj = response.VAL;

                        for (var i = 0; i < myObj.length; i++) {
                            tr = $('<tr>');
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].MRNO + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].BILL_AMOUNT + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].BILL_PRNT_DT + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].BILL_DUE_DT + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].BILL_TYPE + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].PMT_AMT + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].PMT_DT + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].INSTALLMENT_NO + "</td>");
                            tr.append("<td id='td_" + i + "' align='center'>" + myObj[i].BILL_STAT + "</td>");
                            tr.append("</tr>");
                            $('#stattblbody').append(tr);
                        }


                        var table2 = $("#data-table").DataTable({
                            bsort: false
                        });
                    }
                });


            }

        </script>
    </head>

    <body>
        <div class="container">
            <h1 style="display: inline-block;">High Tension Meter Application Bill Details</h1>

             <div class="form-group" style="display: flex; align-items: center;">
                <label for="mrNumber" style="display: inline-block; margin-right: 10px;">Enter MR Number:</label>
                <input type="text" class="form-control" id="mrNumber" required>
                <button id="submitMR" type="button" class="btn btn-primary" onclick="validateMRNumber()">Submit</button>
                <button type="button" class="btn btn-secondary" onclick="location.reload()">Reset</button>
            </div>
        </div>




        <div  id ="stattablediv" style="display: none">
            <table id="data-table" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th style="text-align:center" >MRNO</th>
                        <th style="text-align:center" >BILL_AMOUNT(Rs)</th>
                        <th style="text-align:center" >BILL_PRNT_DT</th>
                        <th style="text-align:center" >BILL_DUE_DT</th>
                        <th style="text-align:center" >BILL_TYPE</th>
                        <th style="text-align:center" >PMT_AMT(Rs)</th>
                        <th style="text-align:center" >PMT_DT</th>
                        <th style="text-align:center" >INSTALLMENT_NO</th>
                        <th style="text-align:center" >BILL_STAT</th>               
                    </tr>
                </thead>
                <tbody id="stattblbody">
            </table>
        </div>
        <div>
    </body>
</html>

