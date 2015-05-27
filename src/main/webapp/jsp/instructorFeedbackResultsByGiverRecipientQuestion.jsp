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
    <script type="text/javascript" src="/js/feedbackResponseComments.js"></script>
    <script type="text/javascript" src="/js/additionalQuestionInfo.js"></script>
    <script type="text/javascript" src="/js/instructorFeedbackResultsAjaxByGRQ.js"></script>
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
            	if (!showAll) {
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
                                                        <%= groupByTeamEnabled == true ? " Teams" : " Students" %>
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
                    // Display warning for too many responses to be displayed normally. (View by sections msg)
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
                } else {
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
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-sm-9 panel-heading-text">
                                    <strong><%=section.equals("None")? "Not in a section" : section%></strong>                        
                                </div>
                                <div class="col-sm-3">
                                    <div class="pull-right">
                                        <a class="btn btn-success btn-xs" id="collapse-panels-button-section-<%=sectionIndex%>" data-toggle="tooltip" title='Collapse or expand all <%=groupByTeamEnabled == true ? "team" : "student"%> panels. You can also click on the panel heading to toggle each one individually.'>
                                            <%=shouldCollapsed ? "Expand " : "Collapse "%>
                                            <%=groupByTeamEnabled == true ? "Teams" : "Students"%>
                                        </a>
                                        &nbsp;
                                        <span class="glyphicon glyphicon-chevron-up"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="panel-collapse collapse in">
                        <div class="panel-body" id="sectionBody-<%=sectionIndex%>">

                <%

                    List<String> giverTeams;
                    if (groupByTeamEnabled) {
                        giverTeams = new ArrayList<String>(data.bundle.rosterSectionTeamNameTable.get(section));
                    } else {
                        giverTeams = new ArrayList<String>();
                        giverTeams.add(Const.DEFAULT_SECTION);
                    }

                    // iterate through the teams. If not grouped by team, a dummy team value is iterated through once.
                    for (String team : giverTeams) {
                        List<String> givers = groupByTeamEnabled ? 
                                              new ArrayList<String>(data.bundle.rosterTeamNameMembersTable.get(team)) : 
                                              new ArrayList<String>(data.bundle.rosterSectionStudentTable.get(section));

                        if (groupByTeamEnabled) {
                            // Display header of group
                %>
                            <div class="panel panel-warning">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-sm-9 panel-heading-text">
                                        <strong><%=team%></strong>                     
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="pull-right">
                                            <a class="btn btn-warning btn-xs" id="collapse-panels-button-team-<%=teamIndex%>" data-toggle="tooltip" title="Collapse or expand all student panels. You can also click on the panel heading to toggle each one individually.">
                                                <%=shouldCollapsed ? "Expand " : "Collapse "%> Students
                                            </a>
                                            &nbsp;
                                            <span class='glyphicon <%=!shouldCollapsed ? "glyphicon-chevron-up" : "glyphicon-chevron-down"%>'></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class='panel-collapse collapse <%=shouldCollapsed ? "" : "in"%>'>
                            <div class="panel-body background-color-warning">
                    <%
                        }

                        for (String giver : givers) {
                            String giverIdentifier = giver.replace(Const.TEAM_OF_EMAIL_OWNER, "");
                            String mailtoStyleAttr = (giverIdentifier.contains("@@"))?"style=\"display:none;\"":"";

                            // Display header of giver
                    %>

                            <div class="panel panel-primary">
                            <div class="panel-heading">
                                From: 
                                <%
                                   if (validator.getInvalidityInfo(FieldValidator.FieldType.EMAIL, giverIdentifier).isEmpty()) {
                                %>  
                                        <div class="middlealign profile-pic-icon-hover inline panel-heading-text" data-link="<%=data.getProfilePictureLink(giverIdentifier)%>">
                                            <strong><%=giverIdentifier%></strong>
                                            <img src="" alt="No Image Given" class="hidden profile-pic-icon-hidden">
                                            <a class="link-in-dark-bg" href="mailTo:<%=giverIdentifier%> " <%=mailtoStyleAttr%>>[<%=giverIdentifier%>]</a>
                                        </div>
                                <%
                                    } else {
                                %>
                                    <div class="inline panel-heading-text">
                                        <strong><%=giverIdentifier%></strong>
                                        <a class="link-in-dark-bg" href="mailTo:<%=giverIdentifier%> " <%=mailtoStyleAttr%>>[<%=giverIdentifier%>]</a>
                                    </div>
                                <%
                                    }
                                    
                                %>
                                <div class="pull-right">
                                <% 
                                    boolean isAllowedToModerate = data.instructor.isAllowedForPrivilege(data.bundle.getSectionFromRoster(giverIdentifier), 
                                                                                                    data.feedbackSessionName, 
                                                                                                    Const.ParamsNames.INSTRUCTOR_PERMISSION_MODIFY_SESSION_COMMENT_IN_SECTIONS);
                                    String disabledAttribute = !isAllowedToModerate? "disabled=\"disabled\"" : "";  
                                    if (data.bundle.isParticipantIdentifierStudent(giverIdentifier)) { 
                                %>
                                        <form class="inline" method="post" action="<%=data.getInstructorEditStudentFeedbackLink() %>" target="_blank">                             
                                            <input type="submit" class="btn btn-primary btn-xs" value="Moderate Responses" <%= disabledAttribute%> data-toggle="tooltip" title="<%=Const.Tooltips.FEEDBACK_SESSION_MODERATE_FEEDBACK%>">
                                            <input type="hidden" name="courseid" value="<%=data.courseId %>">
                                            <input type="hidden" name="fsname" value="<%= data.feedbackSessionName%>">
                                            <input type="hidden" name="moderatedstudent" value=<%= giverIdentifier%>>
                                        </form>
                                <%  } %>
                                    &nbsp;
                                    <div class="display-icon" style="display:inline;">
                                        <span class='glyphicon <%=!shouldCollapsed ? "glyphicon-chevron-up" : "glyphicon-chevron-down"%> pull-right'></span>
                                    </div>                
                                </div>
                           </div>
                            <div class='panel-collapse collapse <%=shouldCollapsed ? "" : "in"%>'>
                            <div class="panel-body">

                        <%
                            if (data.bundle.possibleRecipientsForGiver.containsKey(giver)) {
                                List<String> possibleRecipientsForGiver = new ArrayList<String>(data.bundle.possibleRecipientsForGiver.get(giver));
                                Collections.sort(possibleRecipientsForGiver);
                                int recipientIndex = 1;


                                for (String recipient : possibleRecipientsForGiver) {
                                    String recipientIdentifier = recipient;

                        %>
                                    <div class="row <%=recipientIndex == 1? "": "border-top-gray"%>">
                                      <div class="col-md-2">
                                        <div class="col-md-12">
                                            To:
                                            <%
                                                if (validator.getInvalidityInfo(FieldValidator.FieldType.EMAIL, recipientIdentifier).isEmpty()) {
                                            %>
                                                    <div class="middlealign profile-pic-icon-hover inline-block" data-link="<%=data.getProfilePictureLink(recipientIdentifier)%>">
                                                        <strong><%=recipientIdentifier%></strong>
                                                        <img src="" alt="No Image Given" class="hidden profile-pic-icon-hidden">
                                                    </div>
                                            <%
                                                } else {
                                            %>
                                                    <strong><%=recipientIdentifier%></strong>

                                            <%
                                                }
                                            %> 
                                        </div>
                                        <div class="col-md-12 text-muted small"><br>
                                            From:
                                            <%
                                                if (validator.getInvalidityInfo(FieldValidator.FieldType.EMAIL, giverIdentifier).isEmpty()) {
                                            %>
                                                <div class="middlealign profile-pic-icon-hover inline-block" data-link="<%=data.getProfilePictureLink(giverIdentifier)%>">
                                                    <%=giverIdentifier%>
                                                    <img src="" alt="No Image Given" class="hidden profile-pic-icon-hidden">
                                                </div>
                                            <%
                                                } else {
                                            %>
                                                    <%=giverIdentifier%>
                                            <%
                                                }
                                            %>
                                        </div>
                                      </div>
                                      <div class="col-md-10">
                                      <%
                                        int qnIndx = 0;
                                        for (Map.Entry<String, FeedbackQuestionAttributes> questionEntry : data.bundle.questions.entrySet()) {
                                            String questionId = questionEntry.getKey();
                                            FeedbackQuestionAttributes question = questionEntry.getValue();

                                            if (!responseBundle.get(questionId).get(giver).containsKey(recipient)) {
                                                continue;
                                            }
                                            FeedbackResponseAttributes singleResponse = responseBundle.get(questionId).get(giver).get(recipient);


                                            // start of response display, includes UI for adding/editing comments
                 
                                            FeedbackQuestionDetails questionDetails = question.getQuestionDetails();
                                      %>
                                            <div class="panel panel-info">
                                            <!--Note: When an element has class text-preserve-space, do not insert and HTML spaces-->
                                            <div class="panel-heading">Question <%=question.questionNumber%>: <span class="text-preserve-space"><%
                                                    out.print(InstructorFeedbackResultsPageData.sanitizeForHtml(questionDetails.questionText));
                                                    out.print(questionDetails.getQuestionAdditionalInfoHtml(question.questionNumber, "giver-"+giverIndex+"-recipient-"+recipientIndex));
                                            %></span>
                                            </div>
                                            <div class="panel-body">
                                                <div style="clear:both; overflow: hidden">
                                                    <!--Note: When an element has class text-preserve-space, do not insert and HTML spaces-->
                                                    <div class="pull-left text-preserve-space"><%=data.bundle.getResponseAnswerHtml(singleResponse, question)%></div>
                                                    <button type="button" class="btn btn-default btn-xs icon-button pull-right" id="button_add_comment" 
                                                        onclick="showResponseCommentAddForm(<%=recipientIndex%>,<%=giverIndex%>,<%=qnIndx%>)"
                                                        data-toggle="tooltip" data-placement="top" title="<%=Const.Tooltips.COMMENT_ADD%>"
                                                        <% if (!data.instructor.isAllowedForPrivilege(singleResponse.giverSection,
                                                                singleResponse.feedbackSessionName, Const.ParamsNames.INSTRUCTOR_PERMISSION_SUBMIT_SESSION_IN_SECTIONS)
                                                                || !data.instructor.isAllowedForPrivilege(singleResponse.recipientSection,
                                                                        singleResponse.feedbackSessionName, Const.ParamsNames.INSTRUCTOR_PERMISSION_SUBMIT_SESSION_IN_SECTIONS)) { %>
                                                                disabled="disabled"
                                                        <% } %>
                                                        >
                                                        <span class="glyphicon glyphicon-comment glyphicon-primary"></span>
                                                    </button>
                                                </div>
                                                <% List<FeedbackResponseCommentAttributes> responseComments = data.bundle.responseComments.get(singleResponse.getId()); %>
                                                <ul class="list-group" id="responseCommentTable-<%=recipientIndex%>-<%=giverIndex%>-<%=qnIndx%>"
                                                    style="<%=responseComments != null && responseComments.size() > 0? "margin-top:15px;": "display:none"%>">
                                                <%
                                                    if (responseComments != null && responseComments.size() > 0) {} // comment branch
                                                %>
                                                </ul>
                                            </div>
                                            </div>
                                    <%
                                           // end response display

                                        }  // end question loop
                                        recipientIndex ++;
                                    %>
                                      </div>
                                    </div>
                        <%
                                } // end recipient
                            } // end if giver has recipients
                        %>
                            </div>
                            </div>
                            </div>
                    <%
                        }  //end giver
                        if (groupByTeamEnabled) {
                    %>
                            </div>
                            </div>
                            </div>
                <%
                        }
                    } // end team
                %>
                </div>
                </div>
                </div>
                    
        <%
                } // end section
            } // showAll
       
        %>

        <jsp:include page="<%=Const.ViewURIs.INSTRUCTOR_FEEDBACK_RESULTS_BOTTOM%>" />
        </div>
    </div>

    <jsp:include page="<%=Const.ViewURIs.FOOTER%>" />
</body>
</html>
