package com.github.trentonadams;

import org.glassfish.jersey.server.mvc.Template;
import org.glassfish.jersey.server.mvc.Viewable;

import javax.swing.text.View;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;

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
    @Produces(MediaType.TEXT_HTML)
    @Template(name = "work-table-test")
    @Path("/post")
    public WorkList showWork(final WorkList workList)
    {
        System.out.println(workList);
        return workList;
    }

    @GET
    @Produces(MediaType.TEXT_HTML)
    @Template(name = "work-table-test")
    @Path("/get")
    public Response testWork()
    {
        final WorkList workList1 = new WorkList();
        return Response.ok(new Viewable("work-table-test.jsp", workList1))
            .build();
    }
}
