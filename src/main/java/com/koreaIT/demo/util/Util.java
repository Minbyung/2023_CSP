package com.koreaIT.demo.util;

import java.util.Base64;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import java.util.UUID;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;

public class Util {
	public static boolean empty(String str) {
		
		if (str == null) {
			return true;
		}
		
		return str.trim().length() == 0;
	}

	public static String f(String format, Object... args) {
		return String.format(format, args);
	}

	public static String jsHistoryBack(String msg) {
		
		if (msg == null) {
			msg = "";
		}
		
		return Util.f("""
					<script>
						const msg = '%s'.trim();
						
						if (msg.length > 0) {
							alert(msg);
						}
						
						history.back();
					</script>
				""", msg);
	}

	public static String jsReplace(String msg, String uri) {
		
		if (msg == null) {
			msg = "";
		}
		
		if (uri == null) {
			uri = "";
		}
		
		return Util.f("""
				<script>
					const msg = '%s'.trim();
					
					if (msg.length > 0) {
						alert(msg);
					}
					
					location.replace('%s');
				</script>
			""", msg, uri);
	}
	
	public static String generateInviteCode() {
		return UUID.randomUUID().toString().replaceAll("-", "").substring(0, 10);
	}
	
	public class DateFormatConverter {
	    public static String convertToMySqlFormat(String isoDate) {
	        // ISO 8601 날짜 형식을 파싱합니다.
	        SimpleDateFormat isoFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
	        isoFormat.setTimeZone(TimeZone.getTimeZone("UTC")); // UTC 시간대를 설정합니다.
	        
	        try {
	            Date date = isoFormat.parse(isoDate);
	            // MySQL 형식으로 날짜를 포맷합니다.
	            SimpleDateFormat mysqlFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	            return mysqlFormat.format(date);
	        } catch (ParseException e) {
	            e.printStackTrace();
	            return null;
	        }
	    }
	}
	
	public static String encode(final String clearText) throws NoSuchAlgorithmException {
		return new String(
			Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(clearText.getBytes(StandardCharsets.UTF_8))));
	}
	
	
	
	
	
	
	
	
	
}
