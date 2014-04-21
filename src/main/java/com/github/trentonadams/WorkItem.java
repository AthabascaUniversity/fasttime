package com.github.trentonadams;

import org.codehaus.jackson.map.annotate.JsonSerialize;

import java.util.Calendar;

/**
 * Created by IntelliJ IDEA.
 * <p/>
 * Created :  16/04/14 2:03 PM MST
 * <p/>
 * Modified : $Date$ UTC
 * <p/>
 * Revision : $Revision$
 *
 * @author Trenton D. Adams
 */
public class WorkItem
{
    private Calendar weekStart;
    private Calendar weekEnd;
    private int approvalStatusId;
    private String approvalStatusName;
    private int projectId;
    private String projectName;
    private int taskId;
    private String taskName;
    private int timeSheetLineId;
    private int timeSheetPeriodId;
    private String comment;

    public WorkItem()
    {
        weekStart = Calendar.getInstance();
        weekEnd = Calendar.getInstance();
        approvalStatusId = 2;
        approvalStatusName = "Status Name";
        projectId = 3;
        projectName = "Project Name";
        taskId = 4;
        taskName = "Task Name";
        timeSheetLineId = 5;
        timeSheetPeriodId = 6;
        comment = "comment";
    }

    public Calendar getWeekStart()
    {
        return weekStart;
    }

    public void setWeekStart(Calendar weekStart)
    {
        this.weekStart = weekStart;
    }

    public Calendar getWeekEnd()
    {
        return weekEnd;
    }

    public void setWeekEnd(Calendar weekEnd)
    {
        this.weekEnd = weekEnd;
    }

    public int getApprovalStatusId()
    {
        return approvalStatusId;
    }

    public void setApprovalStatusId(int approvalStatusId)
    {
        this.approvalStatusId = approvalStatusId;
    }

    public String getApprovalStatusName()
    {
        return approvalStatusName;
    }

    public void setApprovalStatusName(String approvalStatusName)
    {
        this.approvalStatusName = approvalStatusName;
    }

    public int getProjectId()
    {
        return projectId;
    }

    public void setProjectId(int projectId)
    {
        this.projectId = projectId;
    }

    public String getProjectName()
    {
        return projectName;
    }

    public void setProjectName(String projectName)
    {
        this.projectName = projectName;
    }

    public int getTaskId()
    {
        return taskId;
    }

    public void setTaskId(int taskId)
    {
        this.taskId = taskId;
    }

    public String getTaskName()
    {
        return taskName;
    }

    public void setTaskName(String taskName)
    {
        this.taskName = taskName;
    }

    public int getTimeSheetLineId()
    {
        return timeSheetLineId;
    }

    public void setTimeSheetLineId(int timeSheetLineId)
    {
        this.timeSheetLineId = timeSheetLineId;
    }

    public int getTimeSheetPeriodId()
    {
        return timeSheetPeriodId;
    }

    public void setTimeSheetPeriodId(int timeSheetPeriodId)
    {
        this.timeSheetPeriodId = timeSheetPeriodId;
    }

    public String getComment()
    {
        return comment;
    }

    public void setComment(String comment)
    {
        this.comment = comment;
    }

    @Override
    public String toString()
    {
        return "WorkItem{" +
            "weekStart=" + weekStart +
            ", weekEnd=" + weekEnd +
            ", approvalStatusId=" + approvalStatusId +
            ", approvalStatusName='" + approvalStatusName + '\'' +
            ", projectId=" + projectId +
            ", projectName='" + projectName + '\'' +
            ", taskId=" + taskId +
            ", taskName='" + taskName + '\'' +
            ", timeSheetLineId=" + timeSheetLineId +
            ", timeSheetPeriodId=" + timeSheetPeriodId +
            ", comment='" + comment + '\'' +
            '}';
    }
}
