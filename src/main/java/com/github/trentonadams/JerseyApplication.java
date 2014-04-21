package com.github.trentonadams;

import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.server.ResourceConfig;
import org.glassfish.jersey.server.mvc.MvcFeature;

/**
 * Created by IntelliJ IDEA.
 * <p/>
 * Created :  15/04/14 11:12 PM MST
 * <p/>
 * Modified : $Date$ UTC
 * <p/>
 * Revision : $Revision$
 *
 * @author Trenton D. Adams
 */
public class JerseyApplication extends ResourceConfig
{
    public JerseyApplication()
    {
        property(MvcFeature.TEMPLATE_BASE_PATH, "/");
        register(JacksonFeature.class);
        register(MvcFeature.class);
    }
}
