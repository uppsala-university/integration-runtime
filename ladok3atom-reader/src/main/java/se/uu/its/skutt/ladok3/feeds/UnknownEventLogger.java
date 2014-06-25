package se.uu.its.skutt.ladok3.feeds;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import org.apache.abdera.model.Entry;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class UnknownEventLogger {
	
	private static final String DUMPDIR = "unknownEvents";
	private static long count;
	private Log log = LogFactory.getLog(this.getClass());
	
	
	static {
		File f = new File(DUMPDIR);
		if (!f.exists()) {
				f.mkdir();
		}
		count=0;
	}

	
	public synchronized String dumpUnknownEntry(String s) throws IOException {
		log.info("dumpUnknownEntry " + s);
		PrintWriter out = new PrintWriter(DUMPDIR+"/"+count);
		out.print(s.toString());
		out.close();
		count++;
		return s;
	}
}
