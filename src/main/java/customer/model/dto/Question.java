package customer.model.dto;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import common.Attachment;
import common.Form;

public class Question extends Form{
	
	private int rowNo;
	private String title;
	private List<Attachment> attachments = new ArrayList<>();
	
	public Question() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Question(int no, String writer, String title, String content, Date regDate) {
		super(no, writer, content, regDate);
		this.title = title;
		// TODO Auto-generated constructor stub
	}

	public Question(int no, String writer, String content, Date regDate, String title, List<Attachment> attachments) {
		super(no, writer, content, regDate);
		this.title = title;
		this.attachments = attachments;
	}

	public Question(int no, String writer, String content, Date regDate, int rowNo, String title,
			List<Attachment> attachments) {
		super(no, writer, content, regDate);
		this.rowNo = rowNo;
		this.title = title;
		this.attachments = attachments;
	}

	public int getRowNo() {
		return rowNo;
	}

	public void setRowNo(int rowNo) {
		this.rowNo = rowNo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public List<Attachment> getAttachments() {
		return attachments;
	}

	public void setAttachments(List<Attachment> attachments) {
		this.attachments = attachments;
	}

	@Override
	public String toString() {
		return "Question [rowNo=" + rowNo + ", title=" + title + ", attachments=" + attachments + ", toString()="
				+ super.toString() + "]";
	}

	// addAttachment
	public void addAttachment(Attachment attach) {
		this.attachments.add(attach);
	}
}
