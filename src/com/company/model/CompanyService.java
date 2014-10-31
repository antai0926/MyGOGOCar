package com.company.model;

import java.io.IOException;
import java.util.List;

public class CompanyService {
	
	private ICompanyDAO dao;
	
	public CompanyService() {
		dao = new CompanyDAO();
	}
	
	// 驗證帳號是否重複
	synchronized public boolean accountExists(String account) throws IOException {
		boolean existAccount = false; // 檢查account是否已經存在
		List<CompanyVO> list = dao.getAll();
		for (CompanyVO cv : list) {
			if (cv.getComAccount().equals(account.trim())) {
				existAccount = true;
				break;
			}
		}
		return existAccount;
	}
	
	// 驗證統一編號是否重複
	synchronized public boolean verifyVAT(String VAT) throws IOException {
		boolean existVAT = false; // 檢查VAT是否已經存在
		List<CompanyVO> list = dao.getAll();
		for (CompanyVO cv : list) {
			if (cv.getComVAT().equals(VAT.trim())) {
				existVAT = true;
				break;
			}
		}
		return existVAT;
	}
	
	public CompanyVO addCompany(String comAccount,String comPwd,String comName,String comOwner,
		    String comAddr, String comTel, String comFax, String comVAT, byte[] comPic) {
		
		CompanyVO comVO = new CompanyVO();
		
		comVO.setComAccount(comAccount);
		comVO.setComPwd(comPwd);
		comVO.setComName(comName);
		comVO.setComOwner(comOwner);
		comVO.setComAddr(comAddr);
		comVO.setComTel(comTel);
		comVO.setComFax(comFax);
		comVO.setComVAT(comVAT);
		comVO.setComPic(comPic);
		
		dao.insert(comVO);
		
		return comVO;
	}
	
	public CompanyVO updateCompany(Integer comID, String comAccount,String comPwd,String comName,String comOwner,
		    String comAddr, String comTel, String comFax, String comVAT, byte[] comPic) {
		
		CompanyVO comVO = new CompanyVO();
		
		comVO.setComID(comID);
		comVO.setComAccount(comAccount);
		comVO.setComPwd(comPwd);
		comVO.setComName(comName);
		comVO.setComOwner(comOwner);
		comVO.setComAddr(comAddr);
		comVO.setComTel(comTel);
		comVO.setComFax(comFax);
		comVO.setComVAT(comVAT);
		comVO.setComPic(comPic);
		dao.update(comVO);
		
		return dao.findByPrimaryKey(comID);
	}
	
	public CompanyVO getOneCom(Integer comID) {
		return dao.findByPrimaryKey(comID);
	}
}