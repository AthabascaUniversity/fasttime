package com.github.trentonadams;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * Created by IntelliJ IDEA.
 * <p/>
 * Created :  15/04/14 10:17 PM MST
 * <p/>
 * Modified : $Date$ UTC
 * <p/>
 * Revision : $Revision$
 *
 * @author Trenton D. Adams
 */

@Path("working")
public class Work
{
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/json")
    public Data isWorkingJson()
    {
        return new Data().setWorking(true);
    }

    @GET
    @Produces(MediaType.APPLICATION_XML)
    @Path("/xml")
    public Data isWorkingXml()
    {
        return new Data().setWorking(true);
    }
}
