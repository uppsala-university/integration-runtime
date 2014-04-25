package se.uu.its.skutt.ladok3.feeds.dto;

import java.util.Date;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "KursTillStatus3Handelse", namespace = "http://schemas.ladok.se/utbildningsinformation")
public class KursTillStatus3Handelse {
	
	private String handelseUID;
	private String kurskod;
	private Date handelseTid;
	
	@XmlElement(name = "HandelseUID", namespace = "http://schemas.ladok.se")
	public String getHandelseUID() {
		return handelseUID;
	}
	public void setHandelseUID(String handelseUID) {
		this.handelseUID = handelseUID;
	}
	@XmlElement(name = "Kurskod", namespace = "http://schemas.ladok.se/utbildningsinformation")
	public String getKurskod() {
		return kurskod;
	}
	public void setKurskod(String kurskod) {
		this.kurskod = kurskod;
	}
	@XmlElement(name = "Handelsetid", namespace = "http://schemas.ladok.se")
	public Date getHandelseTid() {
		return handelseTid;
	}
	public void setHandelseTid(Date handelseTid) {
		this.handelseTid = handelseTid;
	}
	
	public String toString() {
		return(handelseUID + ":" + handelseTid + ":" + kurskod);
	}

}
