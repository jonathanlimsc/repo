<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashSet"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.LinkedHashSet"%>
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
    boolean isShowingAllSections = data.bundle.isComplete;
    boolean shouldCollapsed = data.bundle.responses.size() > 500;
    boolean isGroupByTeamEnabled = (data.groupByTeam == null || !data.groupByTeam.equals("on")) ? false : true;
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
                if (!isShowingAllSections) {   // if the data retrieved is not the entire data of the course
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
                                                <a class="btn btn-success btn-xs" id="collapse-panels-button-section-<%=sectionIndex%>" data-toggle="tooltip" title='Collapse or expand all <%=isGroupByTeamEnabled ? "team" : "student"%> panels. You can also click on the panel heading to toggle each one individually.' style="display:none;">
                                                    Expand
                                                    <%=isGroupByTeamEnabled ? " Teams" : " Students"%>
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
                                                <a class="btn btn-success btn-xs" id="collapse-panels-button-section-<%=sectionIndex%>" data-toggle="tooltip" title='Collapse or expand all <%=isGroupByTeamEnabled ? "team" : "student"%> panels. You can also click on the panel heading to toggle each one individually.' style="display:none;">
                                                    Expand
                                                    <%=isGroupByTeamEnabled ? " Teams" : " Students"%>
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
                    Map<String, FeedbackQuestionAttributes> questions = data.bundle.questions;
                    int giverIndex = data.startIndex;
                    int sectionIndex = 0;
                    int teamIndex = 0;

                    List<String> questionIds = data.bundle.getQuestionIdsSortedByQuestionNumber();

                    Set<String> sectionsInCourse = new LinkedHashSet<String>();
                    sectionsInCourse.add(Const.DEFAULT_SECTION);
                    sectionsInCourse.addAll(data.bundle.rosterSectionTeamNameTable.keySet());

                    for (String section : sectionsInCourse) {
                        sectionIndex++;
                        // Display header of section
            %>
                        <div class="panel panel-success">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-sm-9 panel-heading-text">
                                    <strong><%=section.equals("None") ? "Not in a section" : section%></strong>                        
                                </div>
                                <div class="col-sm-3">
                                    <div class="pull-right">
                                        <a class="btn btn-success btn-xs" id="collapse-panels-button-section-<%=sectionIndex%>" data-toggle="tooltip" title='Collapse or expand all <%=isGroupByTeamEnabled ? "team" : "student"%> panels. You can also click on the panel heading to toggle each one individually.'>
                                            <%=shouldCollapsed ? "Expand " : "Collapse "%>
                                            <%=isGroupByTeamEnabled ? "Teams" : "Students"%>
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
                        if (isGroupByTeamEnabled) {
                            giverTeams = new ArrayList<String>(data.bundle.getMembersOfSection(section));
                        } else {
                            giverTeams = new ArrayList<String>();
                            giverTeams.add(Const.DEFAULT_SECTION); // a dummy team
                        }

                        if (data.bundle.anonymousGiversInSection.containsKey(section)) {
                            Set<String> anonymousGivers = data.bundle.anonymousGiversInSection.get(section); 
                            for (String anonymousGiver : anonymousGivers) {
                                giverTeams.add(data.bundle.getTeamNameForEmail(anonymousGiver));
                            }
                        }

                        // Iterate through the teams. If not grouped by team, a dummy team value is iterated through once.
                        for (String team : giverTeams) {
                            if (team.equals(Const.GENERAL_QUESTION)) { // in Giver >*>*, skip %GENERAL% (No specific participant) as it cannot be a giver
                                continue;                           
                            }

                            // Prepare feedback givers in the current team
                            boolean isAnonymousTeam = data.bundle.isAnonymousTeam(section, team, isGroupByTeamEnabled);
                            List<String> givers = data.bundle.getPossibleGiversInTeam(isGroupByTeamEnabled, isAnonymousTeam, section, team);
                            
                            if (isGroupByTeamEnabled) {  // Display statistics for the whole team
                        %>
                                <div class="panel panel-warning">
                                <div class="panel-heading">
                                    <div class="inline panel-heading-text">
                                        <strong><%=team%></strong>
                                    </div>
                                    <span class='glyphicon <%=!shouldCollapsed ? "glyphicon-chevron-up" : "glyphicon-chevron-down"%> pull-right'></span>
                                </div>
                                <div class='panel-collapse collapse <%=shouldCollapsed ? "" : "in"%>'>
                                <div class="panel-body background-color-warning">
                                    <div class="resultStatistics">
                                    <h3><%=team%> Statistics for Given Responses </h3>
                                    <hr class="margin-top-0">   
                                <%        
                                    if (data.bundle.mapOfQuestionResponsesForGiverTeam.containsKey(team)) {
                                        // Display statistics for team
                                %>
                               
                                <%
                                    // By Question
                                    int questionIndex = -1;

                                    for (String questionId : questionIds)  {
                                        if (!data.bundle.mapOfQuestionResponsesForGiverTeam.get(team).containsKey(questionId)) {
                                            continue;
                                        }
                                        FeedbackQuestionAttributes question = questions.get(questionId);

                                        FeedbackQuestionDetails questionDetails = question.getQuestionDetails();
                                        String statsHtml = questionDetails.getQuestionResultStatisticsHtml(
                                                                                data.bundle.mapOfQuestionResponsesForGiverTeam.get(team).
                                                                                get(questionId), question, data, data.bundle, "giver-question-recipient");

                                        if (!statsHtml.isEmpty()) {
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
                                            <hr>
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
                            %>  
                                <div class="row">
                                <div class="col-sm-9">
                                    <h3><%=team%> Detailed Responses </h3>
                                </div>
                                <div class="col-sm-3 h3">
                                    <a class="btn btn-warning btn-xs pull-right" id="collapse-panels-button-team-<%=teamIndex%>" data-toggle="tooltip" title="Collapse or expand all student panels. You can also click on the panel heading to toggle each one individually.">
                                        <%=shouldCollapsed ? "Expand " : "Collapse "%> Students
                                    </a>
                                </div>
                                </div>
                                <hr class="margin-top-0">
                            <%
                                
                            }   // end of team statistics
                            else {
                        %>
                                <div class='panel-collapse collapse <%=shouldCollapsed ? "" : "in"%>'>
                        <%
                            }
                        %>
                                </div>
                            <% 
                                Collections.sort(givers);
                                // display for giver
                                for (String giver : givers) {
                                    String giverIdentifier = giver.replace(Const.TEAM_OF_EMAIL_OWNER, "");
                                    giverIdentifier = data.bundle.getNameFromEmail(giverIdentifier);
                                    String mailtoStyleAttr = (data.bundle.isEmailOfPersonFromRoster(giver))?"style=\"display:none;\"":"";

                                    boolean isGiverWithResponses = team.equals(Const.USER_TEAM_FOR_INSTRUCTOR) ? 
                                                                   data.bundle.isInstructorGiver(giver) : 
                                                                   data.bundle.isStudentGiver(giver);

                                    String panelClass = isGiverWithResponses ? "panel-primary" : "panel-default";
                                    String buttonClass = isGiverWithResponses ? "btn-primary" : "btn-default";
                            %>
                                    <div class="panel <%= panelClass %>">
                                    <div class="panel-heading">
                                        From: 
                                        <%
                                            if (validator.getInvalidityInfo(FieldValidator.FieldType.EMAIL, giver).isEmpty()) {
                                        %>
                                                <div class="middlealign profile-pic-icon-hover inline panel-heading-text" data-link="<%=data.getProfilePictureLink(giver)%>">
                                                    <strong><%=giverIdentifier%></strong>
                                                    <img src="" alt="No Image Given" class="hidden profile-pic-icon-hidden">
                                                    <a class="link-in-dark-bg" href="mailTo:<%=giver%> " <%=mailtoStyleAttr%>>[<%=giver%>]</a>
                                                </div>
                                        <%
                                            } else {
                                        %>
                                            <div class="inline panel-heading-text">
                                                <strong><%=giverIdentifier%></strong>
                                                <a class="link-in-dark-bg" href="mailTo:<%=giver%> " <%=mailtoStyleAttr%>>[<%=giver%>]</a>
                                            </div>
                                        <%
                                            }
                                            // Moderations button    
                                        %>

                                        <div class="pull-right">
                                        <% 
                                            boolean isAllowedToModerate = data.instructor.isAllowedForPrivilege(data.bundle.getSectionFromRoster(giver), 
                                                                                                             data.feedbackSessionName, 
                                                                                                             Const.ParamsNames.INSTRUCTOR_PERMISSION_MODIFY_SESSION_COMMENT_IN_SECTIONS);
                                            String disabledAttribute = !isAllowedToModerate? "disabled=\"disabled\"" : "";
                                            if (data.bundle.isParticipantIdentifierStudent(giver)) { 
                                        %>
                                                <form class="inline" method="post" action="<%=data.getInstructorEditStudentFeedbackLink() %>" target="_blank"> 
                                                
                                                    <input type="submit" class="btn <%=buttonClass %> btn-xs" value="Moderate Responses" <%= disabledAttribute %> data-toggle="tooltip" title="<%=Const.Tooltips.FEEDBACK_SESSION_MODERATE_FEEDBACK%>">
                                                    <input type="hidden" name="courseid" value="<%=data.courseId %>">
                                                    <input type="hidden" name="fsname" value="<%= data.feedbackSessionName%>">
                                                    <input type="hidden" name="moderatedstudent" value=<%= giver%>>
                                                
                                                </form>
                                        <% 
                                            } // End of Moderations button
                                            // Close giver's header
                                        %>
                                            &nbsp;
                                            <div class="display-icon" style="display:inline;">
                                                <span class='glyphicon <%=!shouldCollapsed ? "glyphicon-chevron-up" : "glyphicon-chevron-down"%> pull-right'></span>
                                            </div>                
                                        </div>
                                    </div>

                                        <div class='panel-collapse collapse <%=shouldCollapsed ? "" : "in"%>'>
                                        <div class="panel-body">
                                    <%

                                         if (!isGiverWithResponses) {
                                            // display 'no responses' msg
                                    %>
                                                <i>There are no responses given by this user</i>
                                            </div> <!-- close giver tags TODO: dont do this like this -->
                                            </div>
                                            </div>
                                    <%
                                            continue; // skip to the next giver
                                        }
                                    %>
                                    <%
                                        // questions level
                                        int questionIndex = 0;
                                        for (String questionId : questionIds) {
                                            FeedbackQuestionAttributes question = data.bundle.questions.get(questionId);
                                            FeedbackQuestionDetails questionDetails = question.getQuestionDetails();


                                            questionIndex += 1;

                                            // Get all responses from the giver for the question with id questionId
                                            List<FeedbackResponseAttributes> responsesFromGiver = new ArrayList<FeedbackResponseAttributes>();

                                            List<String> recipients = team.equals(Const.USER_TEAM_FOR_INSTRUCTOR) ? 
                                                                      new ArrayList<String>(data.bundle.existingRecipientsForInstructorGiver.get(giver)) :
                                                                      new ArrayList<String>(data.bundle.existingRecipientsForStudentGiver.get(giver));
                                            for (String recipient : recipients) {
                                                boolean isExistingResponse = data.bundle.isExistingResponse(questionId, giver, recipient);
                                                if (!isExistingResponse) {
                                                    continue;
                                                }
                                                FeedbackResponseAttributes feedbackResponse = data.bundle.getFeedbackResponse(questionId, giver, recipient);

                                                boolean isResponseInRightSection = feedbackResponse.giverSection.equals(section);
                                                if (!isResponseInRightSection) {
                                                    continue;
                                                }

                                                responsesFromGiver.add(feedbackResponse);
                                            }

                                            if (responsesFromGiver.isEmpty()) {
                                                // no response for current (question, giver, *)
                                                continue;   
                                            }
                                    %>
                                            <div class="panel panel-info">
                                                <!--Note: When an element has class text-preserve-space, do not insert and HTML spaces-->
                                                <div class="panel-heading">Question <%=question.questionNumber%>: 
                                                    <span class="text-preserve-space"><%
                                                            out.print(InstructorFeedbackResultsPageData.sanitizeForHtml(questionDetails.questionText));
                                                            out.print(questionDetails.getQuestionAdditionalInfoHtml(question.questionNumber, "giver-"+giverIndex+"-question-"+questionIndex));%></span>
                                                </div>

                                                <div class="panel-body padding-0">
                                            <%
                                                if (!responsesFromGiver.isEmpty()) {
                                            %>
                                                    <div class="resultStatistics">
                                                        <%=questionDetails.getQuestionResultStatisticsHtml(responsesFromGiver, question, data, data.bundle, "giver-question-recipient")%>
                                                    </div>
                                            <%
                                                }
                                            %>
                                                <table class="table table-striped table-bordered dataTable margin-0">
                                                    <thead class="background-color-medium-gray text-color-gray font-weight-normal">
                                                        <tr>
                                                            <th>Photo</th>
                                                            <th id="button_sortTo" class="button-sort-none" onclick="toggleSort(this,2)" style="width: 15%;">
                                                                Recipient
                                                                <span class="icon-sort unsorted"></span>
                                                            </th>
                                                            <th id="button_sortFromTeam" class="button-sort-ascending" onclick="toggleSort(this,3)" style="width: 15%;">
                                                                Team
                                                                <span class="icon-sort unsorted"></span>
                                                            </th>
                                                            <th id="button_sortFeedback" class="button-sort-none" onclick="toggleSort(this,4)">
                                                                Feedback
                                                                <span class="icon-sort unsorted"></span>
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    <%
                                                        List<String> possibleReceivers = 
                                                                question.giverType.isTeam() ? 
                                                                data.bundle.getPossibleRecipients(question, data.bundle.getFullNameFromRoster(giver)) :
                                                                data.bundle.getPossibleRecipients(question, giver);

                                                        for (String recipient : possibleReceivers) {
                                                            FeedbackResponseAttributes feedbackResponse = null;
                                                            boolean isExistingResponse = data.bundle.isExistingResponse(questionId, giver, recipient);
                                                            if (isExistingResponse) {
                                                                    feedbackResponse = data.bundle.getFeedbackResponse(questionId, giver, recipient);
                                                                }

                                                            String recipientName = data.bundle.getNameForEmail(recipient);
                                                            String recipientTeamName = data.bundle.getTeamNameForEmail(recipient);

                                                            if (isExistingResponse 
                                                                || questionDetails.shouldShowNoResponseText(giver, recipient, question)) {
                                                    %>
                                                                <tr>
                                                                <%
                                                                    if (validator.getInvalidityInfo(FieldValidator.FieldType.EMAIL, recipient).isEmpty()) {
                                                                %>
                                                                        <td class="middlealign">
                                                                            <div class="profile-pic-icon-click align-center" data-link="<%=data.getProfilePictureLink(recipient)%>">
                                                                                <a class="student-profile-pic-view-link btn-link">
                                                                                    View Photo
                                                                                </a>
                                                                                <img src="" alt="No Image Given" class="hidden">
                                                                            </div>
                                                                        </td>
                                                                <%
                                                                        } else {
                                                                %>
                                                                            <td class="middlealign">
                                                                                <div class="align-center" data-link="">
                                                                                    <a class="student-profile-pic-view-link btn-link">
                                                                                        No Photo
                                                                                    </a>
                                                                                </div>
                                                                            </td>
                                                                <%
                                                                        }
                                                                %>
                                                                        <td class="middlealign"><%=recipientName%></td>
                                                                        <td class="middlealign"><%=recipientTeamName%></td>
                                                                    <%
                                                                        if (isExistingResponse) {
                                                                    %>
                                                                            <!--Note: When an element has class text-preserve-space, do not insert and HTML spaces-->
                                                                            <td class="text-preserve-space"><%=data.bundle.getResponseAnswerHtml(feedbackResponse, question)%></td>
                                                                    <%
                                                                        } else {
                                                                    %>  
                                                                            <!--Note: When an element has class text-preserve-space, do not insert and HTML spaces-->
                                                                            <td class="text-preserve-space color_neutral"><%=questionDetails.getNoResponseTextInHtml(giver, recipient, data.bundle, question)%></td>                                                             
                                                                    <%  
                                                                        }
                                                                    %>
                                                                </tr>
                                                    <%  
                                                            } // end of should show no response text
                                                        }   // end of recipient loop
                                                    %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>   
                                <%
                                        } // End question
                                %> 
                                    </div>
                                    </div></div>
                    <% 
                                } // end giver
                                if (isGroupByTeamEnabled) {
                                    // Close team panels, if the resposnes are grouped by team
                    %>
                                    </div></div></div>
                    <%
                                }
                        } // end team
                    %>
                    </div></div></div>
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