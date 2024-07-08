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

	public void insertNotification(Notification managerNotification) {
		
		notificationDao.insertNotification(managerNotification);
	}

	public List<Notification> getTaggedNotifications(int loginedMemberId) {
		return notificationDao.getTaggedNotifications(loginedMemberId);
	}

	public boolean deleteNotificationById(int id) {
		int rowsAffected = notificationDao.deleteNotificationById(id);
		
		return rowsAffected > 0;
	}

	public boolean deleteAllNotification(int id) {
		int rowsAffected = notificationDao.deleteAllNotification(id);
		return rowsAffected > 0;
	}

	
	
}
