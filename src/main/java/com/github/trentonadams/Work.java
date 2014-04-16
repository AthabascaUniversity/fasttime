package com.github.trentonadams;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

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

@Path("work")
public class Work
{
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/json")
    public WorkList isWorkingJson()
    {
        return new WorkList();
    }

    @GET
    @Produces(MediaType.APPLICATION_XML)
    @Path("/xml")
    public WorkList isWorkingXml()
    {
        return new WorkList();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Path("/post")
    public Response showWork(final WorkList workList)
    {
        System.out.println(workList);
        return Response.ok(Boolean.TRUE).build();
    }
}
