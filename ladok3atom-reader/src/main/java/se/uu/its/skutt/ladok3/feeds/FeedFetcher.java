package se.uu.its.skutt.ladok3.feeds;

import java.io.IOException;
import java.io.InputStream;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.net.ssl.KeyManagerFactory;

import org.apache.abdera.Abdera;
import org.apache.abdera.model.Document;
import org.apache.abdera.model.Entry;
import org.apache.abdera.model.Feed;
import org.apache.abdera.model.Link;
import org.apache.abdera.protocol.Response.ResponseType;
import org.apache.abdera.protocol.client.AbderaClient;
import org.apache.abdera.protocol.client.ClientResponse;
import org.apache.abdera.protocol.client.util.ClientAuthSSLProtocolSocketFactory;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class FeedFetcher {

	public static String TOO_MANY_EVENTS_REQUESTED = "Too many events requested :-(";
	private String feedBase = null;
	private String certificateFile = null;
	private String certificatePwd = null;
	private Log log = LogFactory.getLog(this.getClass());
	private static int MAX_ENTRIES_PER_RUN = 100;

	private Properties properties;

	private boolean useCert = true;


	public FeedFetcher() throws Exception {
		properties = new Properties();
		try {
			InputStream in = this.getClass().getClassLoader().getResourceAsStream("feedfetcher.properties");
			if (in == null) {
				throw new Exception("Unable to find feedfetcher.properties (see feedfetcher.properties.sample)");
			}
			properties.load(in);
			if ((feedBase=properties.getProperty("feedbase")) == null) {
				throw new Exception("Missing property \"feedbase\"");
			}
			if ((certificateFile=properties.getProperty("certificateFile")) == null) {
				//	throw new Exception("Missing property \"certificateFile\"");
				useCert = false;
			}
			if ((certificatePwd=properties.getProperty("certificatePwd")) == null) {
				//	throw new Exception("Missing property \"certificatePwd\"");
			}
		}
		catch (IOException e) {
			log.error("Unable to read feedfetcher.properties");
			throw e;
		}
	}

	private AbderaClient getClient() throws Exception {
		log.info("useCert =" + useCert);
		Abdera abdera = new Abdera();
		AbderaClient client = new AbderaClient(abdera);
		KeyStore keystore;
		try {
			if (useCert) {
				keystore = KeyStore.getInstance("PKCS12");
				keystore.load(this.getClass().getClassLoader().getResourceAsStream(certificateFile), certificatePwd.toCharArray());
				ClientAuthSSLProtocolSocketFactory factory = new ClientAuthSSLProtocolSocketFactory(keystore, certificatePwd, "TLS",KeyManagerFactory.getDefaultAlgorithm(),null);
				AbderaClient.registerFactory(factory, 443);
			}
			return(client);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new Exception(e.getMessage());
		}
	}

	public Feed getFeed(String url) {
		log.info("Fetching feed: " + url);
		try {
			ClientResponse resp = this.getClient().get(url);
			if (resp.getType() == ResponseType.SUCCESS) {
				Document<Feed> doc = resp.getDocument();
				System.out.println(doc.getRoot().getTitle());
				return (doc.getRoot());
			} else {
				return (null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e + " :: " + url);
			return (null);
		}
	}

	private Feed getFeedFromNr(long fromNr) {
		return (this.getFeed(feedBase + fromNr + "-up"));
	}

	/**
	 * Försöker hämta samtliga händelser från och med händelse med nummer
	 * "fromNr" men hämtar aldrig fler än MAX_ENTRIES_PER_RUN händelser per
	 * anrop
	 * 
	 * @param fromNr
	 * @return
	 */
	public List<Entry> getEntries(long fromNr) {
		log.info("Attempting to get all events starting from number " + fromNr);
		Feed f = this.getFeedFromNr(fromNr > 0 ? fromNr -1 : fromNr);
		List<Entry> entries = new ArrayList<Entry>();
		if (f != null) {
			entries.addAll(this.sortEntriesFromFeed(f));
			while (f != null && this.getNextUrl(f) != null && entries.size() < MAX_ENTRIES_PER_RUN) {
				f = this.getFeed(this.getNextUrl(f));
				if (f != null) {
					entries.addAll(this.sortEntriesFromFeed(f));
				}
			}
			log.info("Started from " + fromNr + " and found " + entries.size()
					+ " entries");
		}
		return (entries);
	}


	/**
	 * Vänd på alla entry-objekt i en feed. 
	 * De kommer i fallande kronologisk ordning.
	 * 
	 * @param f
	 * @return
	 */
	private List<Entry> sortEntriesFromFeed(Feed f) {
		List<Entry> entries = new ArrayList<Entry>();
		for ( int i = f.getEntries().size() ;i > 0 ; i-- ) {
			entries.add(f.getEntries().get(i-1)) ;
		}
		return(entries);
	}

	/**
	 * Försöker hämta händelser från och med händelse med nummer "fromNr" till
	 * och med "toNr"
	 * 
	 * @param fromNr
	 * @return
	 * @throws Exception
	 */
	public List<Entry> getEntries(int fromNr, int toNr) throws Exception {
		log.info("Attempting to get events " + fromNr + " to " + toNr);
		Feed f = this.getFeedFromNr(fromNr > 0 ? fromNr -1 : fromNr);
		List<Entry> allEntries = new ArrayList<Entry>();

		List<Entry> feedEntries = this.sortEntriesFromFeed(f);
		for (Entry e : feedEntries) {
			if (EventUtils.getEventNumber(e) <= toNr) {
				allEntries.add(e);
			}
		}
		boolean madeItAllTheWay = false;
		while (f != null && this.getNextUrl(f) != null && !madeItAllTheWay) {
			f = this.getFeed(this.getNextUrl(f));
			if (f != null) {	
				feedEntries = this.sortEntriesFromFeed(f);
				for (Entry e : feedEntries) {
					if (EventUtils.getEventNumber(e) <= toNr) {
						allEntries.add(e);
					} else {
						madeItAllTheWay = true;
						break;
					}
				}
			}
		}
		//if (!madeItAllTheWay) {
		//	log.error("Aieee!!! Unable to get all requested entries...");
		//	throw new Exception(TOO_MANY_EVENTS_REQUESTED);
		//}
		log.info("Found " + allEntries.size() + " entries");
		return (allEntries);
	}

	/**
	 * Extrahera "nästa feed url" ur en feed
	 * 
	 * @param f
	 * @return Url i strängform eller null om url saknas
	 */
	private String getNextUrl(Feed f) {
		String retval = null;
		for (Link link : f.getLinks()) {
			if ("next-archive".equalsIgnoreCase(link.getRel())) {
				retval = link.getAttributeValue("href");
			}
		}
		//URL:er i MIT-feeden stämmer inte.
		if(retval != null) {
			retval = retval.replaceAll("http://mit-ladok3.its.umu.se:8084", "https://api.mit.ladok.se");
			retval = retval.replaceAll("http://mit-ik-ladok3.its.umu.se:8082", "https://api.mit.ladok.se");
		}
		return (retval);
	}
}