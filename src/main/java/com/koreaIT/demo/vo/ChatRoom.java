package com.koreaIT.demo.vo;

import java.util.HashMap;
import java.util.UUID;

import lombok.Data;

@Data
public class ChatRoom {
    private int id; // 채팅방 아이디
    private int senderId; // 참여자 1의 사용자 ID
    private int recipientId; // 참여자 2의 사용자 ID
    private String chatRoomId;
    private String name;
}
