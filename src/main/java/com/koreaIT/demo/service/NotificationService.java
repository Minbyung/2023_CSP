package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.GroupDao;
import com.koreaIT.demo.dao.NotificationDao;
import com.koreaIT.demo.vo.Group;
import com.koreaIT.demo.vo.Notification;

@Service
public class NotificationService {
	
	private NotificationDao notificationDao; 
	
	public NotificationService(NotificationDao notificationDao) {
		this.notificationDao = notificationDao;
	}

	public void insertNotification(Notification writeNotification) {
		
		notificationDao.insertNotification(writeNotification);
	}

	public List<Notification> getWriteNotifications(int loginedMemberId) {
		return notificationDao.getWriteNotifications(loginedMemberId);
	}

	
	
}
