package com.koreaIT.demo.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.koreaIT.demo.interceptor.BeforeActionInterceptor;
import com.koreaIT.demo.interceptor.NeedLoginInterceptor;
import com.koreaIT.demo.interceptor.NeedLogoutInterceptor;

@Configuration
public class MyWebMvcConfigurer implements WebMvcConfigurer {

	private BeforeActionInterceptor beforeActionInterceptor;
	private NeedLoginInterceptor needLoginInterceptor;
	private NeedLogoutInterceptor needLogoutInterceptor;

	public MyWebMvcConfigurer(BeforeActionInterceptor beforeActionInterceptor,
			NeedLoginInterceptor needLoginInterceptor, NeedLogoutInterceptor needLogoutInterceptor) {
		this.beforeActionInterceptor = beforeActionInterceptor;
		this.needLoginInterceptor = needLoginInterceptor;
		this.needLogoutInterceptor = needLogoutInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		InterceptorRegistration ir;
		ir = registry.addInterceptor(beforeActionInterceptor);
		ir.addPathPatterns("/**");
		ir.addPathPatterns("/favicon.ico");
		ir.excludePathPatterns("/rosource/**");
		
		ir = registry.addInterceptor(needLoginInterceptor);
		
		ir.addPathPatterns("/usr/project/detail");
		ir.addPathPatterns("/usr/project/task");
		ir.addPathPatterns("/usr/project/schd");
		ir.addPathPatterns("/usr/project/schd/google");
		ir.addPathPatterns("/usr/project/file");
		ir.addPathPatterns("/usr/project/meeting");
		ir.addPathPatterns("/usr/article/search");
		ir.addPathPatterns("/usr/project/inviteProjectMember");
		
		ir.addPathPatterns("/adm/member/main");
		ir.addPathPatterns("/member/delete");
		ir.addPathPatterns("/member/activate");
		
		ir.addPathPatterns("/usr/article/doWrite");
		ir.addPathPatterns("/usr/article/doUpdate");
		ir.addPathPatterns("/usr/article/doUpdateStatus");
		ir.addPathPatterns("/usr/article/doUpdateDate");
		ir.addPathPatterns("/usr/article/getArticleCountsByStatus");
		ir.addPathPatterns("/usr/article/doDelete");
		ir.addPathPatterns("/usr/article/detail");
		
		ir.addPathPatterns("/usr/dashboard/myProject");
		ir.addPathPatterns("/usr/dashboard/dashboard");
		
		ir.addPathPatterns("/usr/favorite/updateFavorite");
		
		ir.addPathPatterns("/usr/group/doMake");
		
		ir.addPathPatterns("/login");
		ir.addPathPatterns("/saveZoomMeetingRequest");
		ir.addPathPatterns("/oauth/callback");
		ir.addPathPatterns("/usr/project/meeting/doDelete");
		
		ir.addPathPatterns("/usr/member/doLogout");
		ir.addPathPatterns("/usr/member/myPage");
		ir.addPathPatterns("/usr/member/checkPassword");
		ir.addPathPatterns("/usr/member/doCheckPassword");
		ir.addPathPatterns("/usr/member/doModify");
		ir.addPathPatterns("/usr/member/passwordModify");
		ir.addPathPatterns("/usr/member/doPasswordModify");
		
		ir.addPathPatterns("/usr/recommendPoint/doRecommendPoint");
		
		ir.addPathPatterns("/usr/reply/doWrite");
		ir.addPathPatterns("/usr/reply/doModify");
		ir.addPathPatterns("/usr/reply/doDelete");
		
		ir.addPathPatterns("/usr/member/doInvite");
		
		ir.addPathPatterns("/usr/home/chat");
		ir.addPathPatterns("/usr/home/groupChat");
		
		ir = registry.addInterceptor(needLogoutInterceptor);
		ir.addPathPatterns("/usr/member/join");
		ir.addPathPatterns("/usr/member/joinWithInvite");
		ir.addPathPatterns("/usr/member/doJoin");
		ir.addPathPatterns("/usr/member/doJoinWithInvite");
		ir.addPathPatterns("/usr/member/login");
		ir.addPathPatterns("/usr/member/doLogin");
	}

}
