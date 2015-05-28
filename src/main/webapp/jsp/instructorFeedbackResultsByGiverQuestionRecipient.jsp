<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Collections"%>
<%@ page import="teammates.common.util.Const"%>
<%@ page import="teammates.common.util.FieldValidator"%>
<%@ page import="teammates.common.datatransfer.FeedbackParticipantType"%>
<%@ page import="teammates.common.datatransfer.FeedbackResponseAttributes"%>
<%@ page import="teammates.common.datatransfer.FeedbackResponseCommentAttributes"%>
<%@ page import="teammates.common.datatransfer.FeedbackSessionResponseStatus" %>
<%@ page import="teammates.ui.controller.InstructorFeedbackResultsPageData"%>
<%@ page import="teammates.common.datatransfer.FeedbackQuestionDetails"%>
<%@ page import="teammates.common.datatransfer.FeedbackQuestionAttributes"%>
<%
	InstructorFeedbackResultsPageData data = (InstructorFeedbackResultsPageData) request.getAttribute("data");
    FieldValidator validator = new FieldValidator();
    boolean showAll = data.bundle.isComplete;
    boolean shouldCollapsed = data.bundle.responses.size() > 500;
    boolean groupByTeamEnabled = (data.groupByTeam == null || !data.groupByTeam.equals("on")) ? false : true;
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="shortcut icon" href="/favicon.png">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TEAMMATES - Feedback Session Results</title>
    <!-- Bootstrap core CSS -->
    <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap theme -->
    <link href="/bootstrap/css/bootstrap-theme.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/stylesheets/teammatesCommon.css" type="text/css" media="screen">
    <script type="text/javascript" src="/js/googleAnalytics.js"></script>
    <script type="text/javascript" src="/js/jquery-minified.js"></script>
    <script type="text/javascript" src="/js/common.js"></script>
    <script type="text/javascript" src="/js/instructor.js"></script>
    <script type="text/javascript" src="/js/instructorFeedbackResults.js"></script>
    <script type="text/javascript" src="/js/additionalQuestionInfo.js"></script>
    <script type="text/javascript" src="/js/instructorFeedbackResultsAjaxByGQR.js"></script>
    <script type="text/javascript" src="/js/instructorFeedbackResultsAjaxResponseRate.js"></script>
    <jsp:include page="../enableJS.jsp"></jsp:include>
    <!-- Bootstrap core JavaScript ================================================== -->
    <script src="/bootstrap/js/bootstrap.min.js"></script>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>
    <jsp:include page="<%=Const.ViewURIs.INSTRUCTOR_HEADER%>" />

    <div id="frameBody">
        <div id="frameBodyWrapper" class="container">
            <div id="topOfPage"></div>
            <div id="headerOperation">
                <h1>Session Results</h1>
            </div>
            <jsp:include page="<%=Const.ViewURIs.INSTRUCTOR_FEEDBACK_RESULTS_TOP%>" />
            <br>

            <%
            	if (!showAll) {   // if the data retrieved is not the entire data of the course
                    if (data.selectedSection.equals("All")) {
                        int sectionIndex = 0; 
                        for (String section: data.sections) {
            %>
                            <div class="panel panel-success">
                                <div class="panel-heading ajax_submit">
                                    <div class="row">
                                        <div class="col-sm-9 panel-heading-text">
                                            <strong><%=section%></strong>
                                        </div>
                                        <div class="col-sm-3">
                                            <div class="pull-right">
                                                <a class="btn btn-success btn-xs" id="collapse-panels-button-section-<%=sectionIndex%>" data-toggle="tooltip" title='Collapse or expand all <%=groupByTeamEnabled == true ? "team" : "student"%> panels. You can also click on the panel heading to toggle each one individually.' style="display:none;">
                                                    Expand
                                                    <%=groupByTeamEnabled == true ? " Teams" : " Students"%>
                                                </a>
                                                &nbsp;
                                                <div class="display-icon" style="display:inline;">
                                                    <span class="glyphicon glyphicon-chevron-down"></span>
                                                </div>
                                            </div>
                                         </div>
                                    </div>

                                    <form style="display:none;" id="seeMore-<%=sectionIndex%>" class="seeMoreForm-<%=sectionIndex%>" action="<%=Const.ActionURIs.INSTRUCTOR_FEEDBACK_RESULTS_PAGE%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.COURSE_ID%>" value="<%=data.bundle.feedbackSession.courseId%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_SESSION_NAME%>" value="<%=data.bundle.feedbackSession.feedbackSessionName%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_GROUPBYSECTION%>" value="<%=section%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.USER_ID%>" value="<%=data.account.googleId%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_GROUPBYTEAM%>" value="<%=data.groupByTeam%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_SORTTYPE%>" value="<%=data.sortType%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_SHOWSTATS%>" value="on" id="showStats-<%=sectionIndex%>">
                                        <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_MAIN_INDEX%>" value="on" id="mainIndex-<%=sectionIndex%>">
                                    </form>
                                </div>
                                <div class="panel-collapse collapse">
                                <div class="panel-body">
                                </div>
                                </div>
                            </div>
            <%
            	            sectionIndex++;
                        }
            %>
                        <div class="panel panel-success">
                            <div class="panel-heading ajax_submit">
                                <div class="row">
                                        <div class="col-sm-9 panel-heading-text">
                                            <strong>Not in a section</strong>
                                        </div>
                                        <div class="col-sm-3">
                                            <div class="pull-right">
                                                <a class="btn btn-success btn-xs" id="collapse-panels-button-section-<%=sectionIndex%>" data-toggle="tooltip" title='Collapse or expand all <%=groupByTeamEnabled == true ? "team" : "student"%> panels. You can also click on the panel heading to toggle each one individually.' style="display:none;">
                                                    Expand
                                                    <%=groupByTeamEnabled == true ? " Teams" : " Students"%>
                                                </a>
                                                &nbsp;
                                                <div class="display-icon" style="display:inline;">
                                                    <span class="glyphicon glyphicon-chevron-down"></span>
                                                </div>
                                            </div>
                                         </div>
                                    </div>
                                <form style="display:none;" id="seeMore-<%=sectionIndex%>" class="seeMoreForm-<%=sectionIndex%>" action="<%=Const.ActionURIs.INSTRUCTOR_FEEDBACK_RESULTS_PAGE%>">
                                    <input type="hidden" name="<%=Const.ParamsNames.COURSE_ID%>" value="<%=data.bundle.feedbackSession.courseId%>">
                                    <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_SESSION_NAME%>" value="<%=data.bundle.feedbackSession.feedbackSessionName%>">
                                    <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_GROUPBYSECTION%>" value="None">
                                    <input type="hidden" name="<%=Const.ParamsNames.USER_ID%>" value="<%=data.account.googleId%>">
                                    <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_GROUPBYTEAM%>" value="<%=data.groupByTeam%>">
                                    <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_SORTTYPE%>" value="<%=data.sortType%>">
                                    <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_SHOWSTATS%>" value="on">
                                    <input type="hidden" name="<%=Const.ParamsNames.FEEDBACK_RESULTS_MAIN_INDEX%>" value="on" id="mainIndex-<%=sectionIndex%>">
                                </form>
                            </div>
                            <div class="panel-collapse collapse">
                            <div class="panel-body">
                            </div>
                            </div>
                        </div>
            <%
            	    } else {
                         // Display warning message to view the results at the section level instead.
            %>
                         <div class="panel panel-success">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-sm-9 panel-heading-text">
                                        <strong><%=data.selectedSection%></strong>                   
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="pull-right">
                                            <span class="glyphicon glyphicon-chevron-up"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-collapse collapse in">
                                <div class="panel-body" id="sectionBody-0">
                                    <%=InstructorFeedbackResultsPageData.EXCEEDING_RESPONSES_ERROR_MESSAGE%>
                                </div>
                            </div>
                        </div>
            <%
            	   }
                } else {  // showing all
            %>

            
            <%
                // map of (questionId > giverEmail > recipientEmail) > response
                Map<String, Map<String, Map<String, FeedbackResponseAttributes>>> responseBundle = data.bundle.getResponseBundle();
                
                Map<String, FeedbackQuestionAttributes> questions = data.bundle.questions;

                int giverIndex = data.startIndex;
                int sectionIndex = 0;
                int teamIndex = 0;

                Set<String> teamsInSection = new HashSet<String>();
                Set<String> givingTeams = new HashSet<String>();
                            
                Set<String> sectionsInCourse = data.bundle.rosterSectionTeamNameTable.keySet();
                Set<String> givingSections = new HashSet<String>();
                            
                
                for (String section : sectionsInCourse) {
                    giverIndex++;

                    // Display header of section
            %>
                    

                <%

                    List<String> giverTeams;
                    if (groupByTeamEnabled) {
                        giverTeams = new ArrayList<String>(data.bundle.rosterSectionTeamNameTable.get(section));
                    } else {
                        giverTeams = new ArrayList<String>();
                        giverTeams.add(Const.DEFAULT_SECTION);
                    }

                    if (data.bundle.anonymousGiversInSection.containsKey(section)) {
                        Set<String> anonymousGivers = data.bundle.anonymousGiversInSection.get(section); 
                        for (String anonymousGiver : anonymousGivers) {
                            giverTeams.add(data.bundle.getTeamNameForEmail(anonymousGiver));
                        }
                    }

                    // Iterate through the teams. If not grouped by team, a dummy team value is iterated through once.
                    for (String team : giverTeams) {
                        List<String> givers;

                        // Prepare feedback givers in the current team
                        boolean isAnonymousTeam = !data.bundle.rosterTeamNameMembersTable.containsKey(team)
                                               && data.bundle.emailTeamNameTable.containsKey(team);

                        if (groupByTeamEnabled && !isAnonymousTeam) {
                            givers = new ArrayList<String>(data.bundle.rosterTeamNameMembersTable.get(team));
                        } else if (groupByTeamEnabled && isAnonymousTeam) {
                            givers = new ArrayList<String>();
                            String giverName = team;
                            giverName.replace(Const.TEAM_OF_EMAIL_OWNER, "");
                            givers.add(giverName);
                        } else { // TODO handle anonymous team
                            givers = new ArrayList<String>(data.bundle.rosterSectionStudentTable.get(section));
                            for (String anonymousGiver : data.bundle.anonymousGiversInSection.get(section)) {
                                givers.addAll(data.bundle.anonymousGiversInSection.get(anonymousGiver));
                            }
                        }
                        
                        if (groupByTeamEnabled) {  // Display statistics for the whole team
                    %>
                 
                              
                            
                    <%        
                    	if (data.bundle.mapOfQuestionResponsesForGiverTeam.containsKey(team)) {
                    		  // No responses from team
                        		  
                            
                            // Display statistics for teams
                    %>
                           
                            <%
                                // By Question
                                int questionIndex = -1;
                                List<String> questionIds = data.bundle.getQuestionIdsSortedByQuestionNumber();
                                for (String questionId : questionIds)  {
                                    FeedbackQuestionAttributes question = questions.get(questionId);
                                    FeedbackQuestionDetails questionDetails = question.getQuestionDetails();
                                    String statsHtml = questionDetails.getQuestionResultStatisticsHtml(data.bundle.mapOfQuestionResponsesForGiverTeam.get(team).get(questionId), question, data, data.bundle, "giver-question-recipient");

                                    if (statsHtml != "") {
                            %>
                                        <div class="panel panel-info">
                                            <div class="panel-heading">
                                                <!--Note: When an element has class text-preserve-space, do not insert and HTML spaces-->
                                                <strong>Question <%=question.questionNumber%>: </strong><span class="text-preserve-space"><%=data.bundle.getQuestionText(questionId)%><%
                                                    out.print(questionDetails.getQuestionAdditionalInfoHtml(question.questionNumber, ""));
                                                %></span>
                                            </div>
                                            <div class="panel-body padding-0">                
                                                <div class="resultStatistics">
                                                    <%=statsHtml%>
                                                </div>
                                            </div>
                                        </div>
<%
                                    }
                                }
%>
                            
<%
                            } else {
%>
                                    <p class="text-color-gray"><i>No statistics available.</i></p>
<%
                                }
                            
                        }  // end of team statistics
                        
                        // Display detailed responses
                        
                        
                        %>
                            
                        
                        <% 
                        
                            // display for giver
                            for (String giver : givers) {
                            	String mailtoStyleAttr = (data.bundle.isEmailOfPersonFromRoster(giver))?"style=\"display:none;\"":"";
                        %>
                                
                                
                                    From: 
                                    <%
                                        if (validator.getInvalidityInfo(FieldValidator.FieldType.EMAIL, giver).isEmpty()) {
                                    %>
                                            <div class="middlealign profile-pic-icon-hover inline panel-heading-text" data-link="<%=data.getProfilePictureLink(giver)%>">
                                                <strong><%=giver%></strong>
                                                <img src="" alt="No Image Given" class="hidden profile-pic-icon-hidden">
                                                <a class="link-in-dark-bg" href="mailTo:<%=giver%> " <%=mailtoStyleAttr%>>[<%=giver%>]</a>
                                            </div>
                                    <%
                                        } else {
                                    %>
                                        <div class="inline panel-heading-text">
                                            <strong><%=giver%></strong>
                                            <a class="link-in-dark-bg" href="mailTo:<%=giver%> " <%=mailtoStyleAttr%>>[<%=giver%>]</a>
                                        </div>
                                    <%
                                        }
                                        
                                    %>
                                    
                <%
                                // recipient level
                
                
                %>     
                             
                <% 
                
                            } // end giver
                %>
                
                       
                
                <%        
                 
                    } // end team
                %>
                
        <%
                } // end section
                
        %>
           
         
        <%
                
            } /// show all
        %>

        <jsp:include page="<%=Const.ViewURIs.INSTRUCTOR_FEEDBACK_RESULTS_BOTTOM%>" />
        </div>
    </div>

    <jsp:include page="<%=Const.ViewURIs.FOOTER%>" />
</body>
</html>