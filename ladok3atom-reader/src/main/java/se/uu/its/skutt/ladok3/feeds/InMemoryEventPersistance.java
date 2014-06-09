package se.uu.its.skutt.ladok3.feeds;

import org.apache.abdera.model.Entry;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class InMemoryEventPersistance implements EventPersistance {

	private Log log = LogFactory.getLog(this.getClass());
	public long nr;

	public InMemoryEventPersistance() {
		this.nr = 0;
	}

	@Override
	public Entry saveEntry(Entry e) {
		if(this.isUnseenEntry(e)) {
			this.nr = EventUtils.getEventNumber(e);
			log.info("Persisted event: " + EventUtils.getEventNumber(e));
			return(e);
		}
		else {
			log.warn("Already seen event: " + EventUtils.getEventNumber(e));
			return(null);
		}
	}

	@Override
	public long getNextEventNumber() {
		long retval = 0;
		if(nr > 0) {
			return(nr+1);
		}
		log.info("Next event number: " + retval);
		return(retval);
	}

	@Override
	public boolean isUnseenEntry(Entry e) {
		return(this.nr == 0 || EventUtils.getEventNumber(e) > this.nr);
	}

}
