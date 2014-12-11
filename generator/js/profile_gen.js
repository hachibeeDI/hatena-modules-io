(function() {
  var RENDER_TWITTER, SOURCE_EXAMPLE, TEMPLATE, app;

  RENDER_TWITTER = function(id, name) {
    if (id) {
      return "<div class=\"twitter--follow__button--box\">\n  <a\n    class=\"btn twitter--follow__button\"\n    title=\"Twitterで" + name + " (@" + id + ")さんをフォローしましょう\"\n    href=\"https://twitter.com/intent/follow?region=follow_link&screen_name=" + id + "&tw_p=followbutton\">\n    <span class=\"label\">@" + id + "さんをフォロー</span>\n  </a>\n</div>";
    } else {
      return '';
    }
  };

  TEMPLATE = function(hatena_id, nickname, intro, twitter_name, twitter_id, photo_url) {
    if (!hatena_id) {
      return '';
    }
    if (!photo_url) {
      photo_url = "http://cdn1.www.st-hatena.com/users/ha/" + hatena_id + "/profile.gif";
    }
    return "<div class=\"hatena-module hatena-module-profile\">\n  <div class=\"hatena-module-body\">\n    <a href=\"http://" + hatena_id + ".hateblo.jp/about\" class=\"profile-icon-link\">\n      <img src=\"" + photo_url + "\" alt=\"id:" + hatena_id + "\" class=\"profile-icon\">\n    </a>\n    <span class=\"id\">\n      <a href=\"http://" + hatena_id + ".hateblo.jp/about\" class=\"hatena-id-link\"><span data-load-nickname=\"1\" data-user-name=\"" + hatena_id + "\"><span class=\"user-name-nickname\">" + nickname + "</span> <span class=\"user-name-paren\">(</span><span class=\"user-name-hatena-id\">id:" + hatena_id + "</span><span class=\"user-name-paren\">)</span></span></a>\n    </span>\n    <div class=\"profile-description\">\n      <p>" + intro + "</p>\n    </div>\n\n    <div class=\"hatena-follow-button-box btn-subscribe\">\n      <a href=\"#\" class=\"hatena-follow-button\">\n        <span class=\"subscribing\">\n          <span class=\"foreground\">購読中です</span>\n          <span class=\"background\">読者をやめる</span>\n        </span>\n        <span class=\"unsubscribing\" data-track-name=\"profile-widget-subscribe-button\" data-track-once=\"\">\n          <span class=\"foreground\">読者になる</span>\n          <span class=\"background\">読者になる</span>\n        </span>\n      </a>\n      <div class=\"subscription-count-box\" style=\"display: block;\">\n        <i></i>\n        <u></u>\n        <span class=\"subscription-count\">0</span>\n      </div>\n    </div>\n    " + (RENDER_TWITTER(twitter_id, twitter_name)) + "\n  </div>\n</div>";
  };

  app = new Vue({
    el: '#datas',
    data: {
      hatena_id: '',
      hatena_nickname: '',
      introduction: '',
      twitter_name: '',
      twitter_id: '',
      photo_url: '',
      preview_data: ''
    },
    methods: {
      render_preview: function() {
        return this.preview_data = TEMPLATE(this.hatena_id, this.hatena_nickname, this.introduction, this.twitter_name, this.twitter_id, this.photo_url);
      }
    }
  });

  SOURCE_EXAMPLE = document.querySelector('#gen--source-area');

  SOURCE_EXAMPLE.addEventListener('click', function(ev) {
    return SOURCE_EXAMPLE.select();
  });

}).call(this);
