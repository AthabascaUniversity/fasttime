package com.github.trentonadams;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * <p/>
 * Created :  15/04/14 10:58 PM MST
 * <p/>
 * Modified : $Date$ UTC
 * <p/>
 * Revision : $Revision$
 *
 * @author Trenton D. Adams
 */
@XmlRootElement(name = "myWork")
@XmlAccessorType(XmlAccessType.FIELD)
public class WorkList
{
    private List<WorkItem> list;

    public WorkList()
    {
        list = new ArrayList<WorkItem>();
        list.add(new WorkItem());
    }

    public List<WorkItem> getList()
    {
        return list;
    }

    public void setList(List<WorkItem> list)
    {
        this.list = list;
    }

    @Override
    public String toString()
    {
        return "WorkList{" +
            "list=" + list +
            '}';
    }
}
