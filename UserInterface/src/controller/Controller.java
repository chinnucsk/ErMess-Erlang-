 /*
 * Contorller.java
 * Created on Sep 12, 2011, 9:00:50 PM
 */
package controller;

import com.ericsson.otp.erlang.*;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.net.*;

/**
 * The main class of the project which is working like a brain of the software to control everything.
 * @author Amir Almasi
 */
public class Controller {

    OtpNode bar;
    OtpMbox mbox;
    OtpErlangObject o;
    OtpErlangTuple msg;
    OtpErlangPid from;
    OtpErlangAtom ok;
    User user = new User();

    public Controller() {

        try {
            bar = new OtpNode("java", "cake");
            mbox = bar.createMbox();
        } catch (IOException ex) {
            Logger.getLogger(Controller.class.getName()).log(Level.SEVERE, null, ex);
        }
        ok = new OtpErlangAtom("ok");
//        new Thread(new Runnable() {
//
//            public void run() {
//                // do some stuff
////                System.out.println("hey hey");
//                receiveMessage();
//            }
//        }).start();
//        connect();
    }

    /**
     * A method to send the message to the erlang node
     * @param text
     * @return 
     */
//    public boolean sendMessage() {
//
//        System.out.println(bar.cookie());
//        OtpErlangPid pid = mbox.self();
//        System.out.println(pid);
//        while (true) {
//            try {
//                o = mbox.receive();
//                msg = (OtpErlangTuple) o;
//                System.out.println(msg);
//                from = (OtpErlangPid) (msg.elementAt(0));
////                    n = ((OtpErlangLong) (msg.elementAt(1))).bigIntegerValue();
//                OtpErlangObject[] reply = new OtpErlangObject[2];
//                reply[0] = ok;
//                reply[1] = new OtpErlangLong(20);
////                    reply[1] = new OtpErlangLong(Factorial.factorial(n));
//                OtpErlangTuple tuple = new OtpErlangTuple(reply);
//                mbox.send(from, tuple);
//            } catch (OtpErlangExit e) {
//                break;
//            } catch (OtpErlangDecodeException ex) {
//                Logger.getLogger(Controller.class.getName()).log(Level.SEVERE, null, ex);
//            }
//        }
//        return true;
//    }
    /**
     * A function to connect to the client module
     * @return 
     */
    public boolean connect() {
        System.out.println("Controller:connect() is working");
        try {
            String computername = InetAddress.getLocalHost().getHostName();
            OtpErlangObject[] message = new OtpErlangObject[2];
            message[0] = mbox.self();
            message[1] = new OtpErlangAtom("connect");
//            System.out.println(new OtpErlangTuple(message));
//            System.out.println(bar);
            mbox.send("clientChat", "chat_c@" + computername, new OtpErlangTuple(message));
            return true;
        } catch (Exception e) {
            System.out.println("Exception caught =" + e.getMessage());
        }
        return false;
    }

    /**
     * A function to check if any message has been received or not
     * @return Boolean 
     */
    public OtpErlangTuple receiveMessage() {
        System.out.println("Controller:receiveMessage() is working");
        try {
            OtpErlangObject erlangObject = mbox.receive();
            msg = (OtpErlangTuple) erlangObject;
            System.out.println(msg);
//                if (erlangObject != null ){
//                    break;
//                }
            return msg;
        } catch (OtpErlangExit e) {
            System.out.println("An error catch Controller:receiveMessage() 1");
        } catch (OtpErlangDecodeException ex) {
            System.out.println("An error catch Controller:receiveMessage() 2");
            Logger.getLogger(Controller.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * A function to send the message 
     * @param message
     * @return 
     */
    public boolean sendMessage(String message) {
        System.out.println("Controller:sendMessage() is working");
        try {
            String computername = InetAddress.getLocalHost().getHostName();
            OtpErlangObject[] tuple = new OtpErlangObject[2];
            tuple[0] = new OtpErlangAtom("message");
            tuple[1] = new OtpErlangAtom(message);
//            System.out.println(new OtpErlangTuple(message));
//            System.out.println(bar);
            mbox.send("clientChat", "chat_c@" + computername, new OtpErlangTuple(tuple));
            return true;
        } catch (Exception e) {
            System.out.println("Exception caught =" + e.getMessage());
        }
        return false;
    }
}
