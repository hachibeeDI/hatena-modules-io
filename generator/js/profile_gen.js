(function() {
  var TEMPLATE, app;

  TEMPLATE = function(intro, photo_url, twitter_name, twitter_id) {
    return "<div class=\"hatena-module hatena-module-profile\">\n  <div class=\"hatena-module-body\">\n    <a href=\"http://hachibeechan.hateblo.jp/about\" class=\"profile-icon-link\">\n      <img src=\"" + photo_url + "\" alt=\"id:hachibeechan\" class=\"profile-icon\">\n    </a>\n    <span class=\"id\">\n      <a href=\"http://hachibeechan.hateblo.jp/about\" class=\"hatena-id-link\"><span data-load-nickname=\"1\" data-user-name=\"hachibeechan\"><span class=\"user-name-nickname\">はっちん</span> <span class=\"user-name-paren\">(</span><span class=\"user-name-hatena-id\">id:hachibeechan</span><span class=\"user-name-paren\">)</span></span></a>\n    </span>\n    <div class=\"profile-description\">\n      <p>" + intro + "</p>\n    </div>\n\n    <div class=\"hatena-follow-button-box btn-subscribe\">\n      <a href=\"#\" class=\"hatena-follow-button\">\n        <span class=\"subscribing\">\n          <span class=\"foreground\">購読中です</span>\n          <span class=\"background\">読者をやめる</span>\n        </span>\n        <span class=\"unsubscribing\" data-track-name=\"profile-widget-subscribe-button\" data-track-once=\"\">\n          <span class=\"foreground\">読者になる</span>\n          <span class=\"background\">読者になる</span>\n        </span>\n      </a>\n      <div class=\"subscription-count-box\" style=\"display: block;\">\n        <i></i>\n        <u></u>\n        <span class=\"subscription-count\">0</span>\n      </div>\n    </div>\n    <div class=\"twitter--follow__button--box\">\n      <a class=\"btn twitter--follow__button\" title=\"Twitterで" + twitter_name + " (@" + twitter_id + ")さんをフォローしましょう\" href=\"https://twitter.com/intent/follow?region=follow_link?screen_name=" + twitter_id + "?tw_p=followbutton\">\n        <span class=\"label\">@" + twitter_id + "さんをフォロー</span>\n      </a>\n    </div>\n  </div>\n</div>";
  };

  app = new Vue({
    el: '#datas',
    data: {
      introduction: '',
      twitter_name: '',
      twitter_id: '',
      photo_url: '',
      preview_data: ''
    },
    methods: {
      render_preview: function() {
        return this.preview_data = TEMPLATE(this.introduction, this.photo_url, this.twitter_name, this.twitter_id);
      }
    }
  });

}).call(this);
