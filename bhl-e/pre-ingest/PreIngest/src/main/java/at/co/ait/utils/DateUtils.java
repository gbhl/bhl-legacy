package at.co.ait.utils;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtils {
	public static final String DATE_FORMAT_NOW = "yyyy-MM-dd HH:mm:ss";
	public static SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);

	public static String now() {
		Calendar cal = Calendar.getInstance();		
		return sdf.format(cal.getTime());
	}

	public static void main(String arg[]) {
		System.out.println("Now : " + DateUtils.now());
	}

	public static String toDate(Long time) {
		Timestamp timestamp = new Timestamp(time);
		long milliseconds = timestamp.getTime()
				+ (timestamp.getNanos() / 1000000);
		return sdf.format(new Date(milliseconds));
	}

}