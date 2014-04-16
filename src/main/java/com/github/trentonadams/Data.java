package com.github.trentonadams;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

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
/*@XmlRootElement(name = "data")
@XmlAccessorType(XmlAccessType.FIELD)*/
public class Data
{
    private boolean working;

    public boolean isWorking()
    {
        return working;
    }

    public Data setWorking(boolean working)
    {
        this.working = working;
        return this;
    }
}
