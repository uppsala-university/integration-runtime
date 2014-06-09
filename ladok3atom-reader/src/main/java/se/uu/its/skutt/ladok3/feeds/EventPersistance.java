package se.uu.its.skutt.ladok3.feeds;

import org.apache.abdera.model.Entry;

/**
 * Ett interface som styr hur vi håller reda på vilka händelser som har setts.
 * 
 * @author john
 *
 */
public interface EventPersistance {

	/**
	 * Spara en händelse
	 * 
	 * @param e händelse att spara
	 * @return Den sparade händelsen. Null om inget sparades.
	 */
	public abstract Entry saveEntry(Entry e);
	
	/**
	 * Returnerar en siffra som indikerar vilken som är nästa händelse i kön som ska betas av
	 * 
	 * @return
	 */
	public abstract long getNextEventNumber();
	
	/**
	 * Verifiera om en händelse redan har setts
	 * 
	 * @param e Händelse att verifiera
	 * 
	 * @return Returnerar TRUE om händelsen inte har setts ännu
	 */
	public abstract boolean isUnseenEntry(Entry e);

}