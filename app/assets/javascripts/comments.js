/**
 * Created by matthieu on 15/05/15.
 */
document.addEventListener('page:change', function() {
    // Init the side comments
    var SideComments = require('side-comments');
    var currentUser = { id: -1, name: "John Doe", avatarUrl: "http://f.cl.ly/items/0s1a0q1y2Z2k2I193k1y/default-user.png" };
    var sideComments = new SideComments('#portrait_details', currentUser, []);

    // Fetch the comments of each questions
    $('#portrait_details [data-section-id]').each(function(index, section) {
        var questionId = $(section).attr('data-section-id');
        var url = "/api/v1/questions/" + questionId + "/comments";
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                for (var i = 0; i < data.length; i++) {
                    var comment = {
                        id: data[i].id,
                        authorAvatarUrl: data[i].author_avatar_url,
                        authorName: data[i].author_name,
                        comment: data[i].comment,
                        sectionId: data[i].question_id
                    };
                    sideComments.insertComment(comment);
                }
            }
        })
    });

    // Handle the submission of comments
    sideComments.on('commentPosted', function(comment) {
        var url = "/api/v1/questions/" + comment.sectionId + "/comments";
        var data = {
            comment: {
                author_avatar_url : comment.authorAvatarUrl,
                author_name: comment.authorName,
                comment: comment.comment
            }
        };
        $.ajax({
            url: url,
            type: 'POST',
            data: data,
            success: function(savedComment) {
                sideComments.insertComment(comment);
            }
        });
    });
});
