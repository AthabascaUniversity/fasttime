package com.github.trentonadams;

import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.server.ResourceConfig;

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
public class MyRESTExampleApplication extends ResourceConfig
{
    public MyRESTExampleApplication()
    {
        packages("com.github.trentonadams");
        register(JacksonFeature.class);
    }
}
