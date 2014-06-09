package se.uu.its.skutt.ladok3.feeds;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import org.apache.abdera.model.Entry;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class FileBasedEventPersistance implements EventPersistance {
	
	private Log log = LogFactory.getLog(this.getClass());
	private static String FILENAME="ladok.log";
	private static String PROPERTY="last";
	
	static {
		File f = new File("ladok.log");
		if (!f.exists()) {
			try {
				f.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	@Override
	public Entry saveEntry(Entry e) {
		Properties prop = new Properties();
		prop.setProperty(PROPERTY, new Long(EventUtils.getEventNumber(e)).toString());
		try {
			prop.store(new FileOutputStream(FILENAME), null);
			log.info("Saving message: " + EventUtils.getEventNumber(e));
			return(e);
		} catch (Exception e1) {
			e1.printStackTrace();
			return(null);
		} 
	}

	@Override
	public long getNextEventNumber() {
		long current = this.getCurrentNumber();
		if(current == 0) {
			return(0);
		}
		else {
			return(current + 1);
		}
	}

	@Override
	public boolean isUnseenEntry(Entry e) {
		long currentNr = this.getCurrentNumber();
		long eventNr = EventUtils.getEventNumber(e);
		return(currentNr < eventNr);
	}
	
	private long getCurrentNumber() {
		Properties prop = new Properties();
		try {
			prop.load(new FileInputStream(FILENAME));
			if(prop.containsKey(PROPERTY)) {
				return(new Long(prop.getProperty(PROPERTY)));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return(0);
		
	}

}
