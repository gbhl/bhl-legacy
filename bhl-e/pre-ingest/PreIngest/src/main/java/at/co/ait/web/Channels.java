package at.co.ait.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import at.co.ait.domain.oais.TrackingObject;

@Controller
@RequestMapping(value="/channels/*")
public class Channels {
	
    private @Autowired TrackingObject trackingobject;
    
	@RequestMapping(value="index", method=RequestMethod.GET)
	@ModelAttribute("channelList")
	public List<String> getChannels() {
		return null;
	}

}
