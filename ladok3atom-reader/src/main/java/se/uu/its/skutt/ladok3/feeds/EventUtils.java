package se.uu.its.skutt.ladok3.feeds;

import org.apache.abdera.model.Entry;

public class EventUtils {
	
	/**
	 * Extrahera händelsenummer från en Feed-Entry. 
	 * 
	 * Historiskt så har händelsenummer sett ut på lite olika sätt. Men oftast 
	 * har det gått att utläsa från entry.getTitle() på ett eller annat vis. 
	 * 
	 * Ibland som en enkel siffra och ibland som en siffra inbäddad i en 
	 * sträng. Därav denna metod. 
	 * 
	 * @param e
	 * @return Händelsenummer eller 0 vid fel
	 */
	public static long getEventNumber(Entry e) {
		int nr = 0;
		String nrAsString = e.getTitle().replaceAll("[^0-9]", "");
		try {
			nr = new Integer(nrAsString);
		}
		catch(NumberFormatException ex) {
		}
		return(nr);
	}

}
