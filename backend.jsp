<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import ="java.sql.*"%>
<%@page import ="oracle.jdbc.driver.*"%>
<%@page import ="java.util.*"%>
<%@page import ="java.io.*"%>
<%@page import="org.json.simple.*"%>
<%@page import="HTMAConnectionPackage.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%> 

<%

    JSONArray jr = new JSONArray();
    JSONObject mainObj = new JSONObject();

    makeconnectionHTMA mk = null;

    PreparedStatement pst = null;
    ResultSet rs = null;
    

    String req_type = request.getParameter("req_type");
    
    try {

        mk = new makeconnectionHTMA();
        if (mk.con == null) {
            throw new Exception("Can't connect to database");

        }
        mk.con.setAutoCommit(false);

        System.out.println("Database Connected!");


        ////////////////////////////////////////////////////////////////

        if (req_type.equals("REQ")) {

            String mrNumber = request.getParameter("mrNumber");
            
            
            
            JSONObject myjson = new JSONObject();
            
            
            pst = mk.con.prepareStatement("SELECT MRNO||MRNO_CD MRNO, "
                                + "TO_CHAR(BILL_AMT,'999999990.99') bill_amount, "
                                + "TO_CHAR(BILL_PRNT_DT,'dd/mm/rrrr') BILL_PRNT_DT, "
                                + "TO_CHAR(BILL_DUE_DT,'dd/mm/rrrr') BILL_DUE_DT, "
                                + "DECODE(BILL_MKR,'I','INSTALLEMNT BILL','M','MAIN BILL','S','SUPPLEMENTARTY BILL') bill_type, "
                                + "BILL_TEXT, "
                                + "nvl(TO_CHAR(PMT_AMT,'9999999990.99'),0) PMT_AMT, "
                                + "nvl(TO_CHAR(PMT_DT,'DD/MM/RRRR'),' ') PMT_DT, "
                                + "nvl(TO_CHAR(PMT_MTCH_DT,'DD/MM/RRRR'),' ') PMT_MTCH_DT, "
                                + "nvl(to_char(PMNT_MODE),' '), "
                                + "nvl(TO_CHAR(INSTALLMENT_NO),' ') INSTALLMENT_NO, "
                                + "nvl(DECODE(BILL_STAT,'V','Valid Bill','C','Cancelled Bill'),' ') BILL_STAT "
                                + "FROM CL_BILL_TAB WHERE mrno||mrno_cd = ? "
                                + "ORDER BY srl");

            
            pst.setString(1, mrNumber);
            
            rs = pst.executeQuery();

            while (rs.next()) {
                JSONObject temp = new JSONObject();
                temp.put("MRNO", rs.getString("MRNO"));
                temp.put("BILL_AMOUNT", rs.getString("BILL_AMOUNT"));
                temp.put("BILL_PRNT_DT", rs.getString("BILL_PRNT_DT"));
               temp.put("BILL_DUE_DT", rs.getString("BILL_DUE_DT"));
               temp.put("BILL_TYPE", rs.getString("BILL_TYPE"));
               temp.put("PMT_AMT", rs.getString("PMT_AMT"));
               temp.put("PMT_DT", rs.getString("PMT_DT"));
               temp.put("INSTALLMENT_NO", rs.getString("INSTALLMENT_NO"));
               temp.put("BILL_STAT", rs.getString("BILL_STAT"));

                jr.add(temp);
            }
 
            myjson.put("VAL", jr);                                
            response.setContentType("application/json");
            response.setHeader("Cache-Control", "no-cache");
            String str1 = myjson.toString();
            response.getWriter().write(str1);
            response.getWriter().flush();
            response.getWriter().close();
            rs.close();
            pst.close();
            rs = null;
            pst = null;
            mk.con.commit();
        }
        ////////////////////////////////////////////////////////////////

    } catch (SQLDataException sde) {
    } catch (Exception e) {

        if (mk.con != null) {
            try {
                mk.con.rollback();
            } catch (Exception ex) {
            }
        }
        e.printStackTrace();
    } finally {
        if (rs != null) {
            try {
                rs.close();
            } catch (Exception e) {
            }
        }
        if (pst != null) {
            try {
                pst.close();
            } catch (Exception e) {
            }
        }
        if (mk.con != null) {
            try {
                mk.con.close();
            } catch (Exception e) {
            }
        }
        out.flush();
    }

%>


