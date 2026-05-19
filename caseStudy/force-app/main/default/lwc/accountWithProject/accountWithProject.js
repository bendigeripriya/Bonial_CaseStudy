import { api, LightningElement , wire} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import TOTAL_PROJECTS_FIELD from '@salesforce/schema/Account.Total_Projects__c';

import getRelatedProjects from '@salesforce/apex/projectController.getRelatedProjects'
export default class AccountWithProject extends LightningElement {

    @api recordId;

    accountName;
    totalProjects;

    error;

    columnsList = [
        {label:'Project Name', fieldName: 'Name'},
        {label:'Status', fieldName:'Status__c'},
        {label:'Budget', fieldName:'Budget__c', type:'currency'},
    ]

    //Data Collection
    row = [];
    originalProjects = [];
    filteredProjects = [];


    //Pagination
    pageSize = 10;
    currentPage = 1;
    totalRecords = 0;
    totalPages = 0;

    //Filters
    selectedStatus = '';
    showOnlyActive = false;

    statusOptions = [
        {label:'All', value:''},
        {label:'Planned', value:'Planned'},
        {label:'Active', value:'Active'},
        {label:'Completed', value:'Completed'}

    ]
    
    //Account Details
    @wire(getRecord, {
        recordId: '$recordId', 
        fields: [ACCOUNT_NAME_FIELD, TOTAL_PROJECTS_FIELD]
    })
    wiredAccount({error, data}){
        if(data){
            this.accountName = data.fields.Name.value;
            this.totalProjects = data.fields.Total_Projects__c.value;
        }
        if(error){
            this.error = error;
            console.error(error);
        }
    }

    //Load related projects

    @wire(getRelatedProjects, {accountId : '$recordId'})
    wiredProjects({error, data}){
        if(data){

            this.originalProjects = data;

            this.applyFilters();

        }
        if(error){
            this.error = error;
            this.row = undefined;
            console.error(error);
        }
    }


    //Status Filter
    handleStatusChange(event){
        this.selectedStatus = event.detail.value;
        this.applyFilters();
    }


    //Toggle Filter
    handleToggleChange(event){
        this.showOnlyActive = event.detail.checked;
        this.applyFilters();
    }


    applyFilters(){

        let temp = [...this.originalProjects];

        if(this.showOnlyActive){
            temp = temp.filter(project => {
                return project.Status__c === 'Active';
            })
        } else{

            if(this.selectedStatus){
                temp = temp.filter(project => {
                    return project.Status__c === this.selectedStatus;
                })
            }

        }
       
        this.filteredProjects = temp;
        
        this.currentPage = 1;
        this.totalPages = Math.ceil(this.filteredProjects.length / this.pageSize);

        this.updatePaginatedData();
    }

    updatePaginatedData(){
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;

        this.row = this.filteredProjects.slice(start, end);
        }

    handlePrevious(){
        if(this.currentPage > 1){
            this.currentPage--;
            this.updatePaginatedData();
        }
    }

    handleNext(){
        if(this.currentPage < this.totalPages){
            this.currentPage++;
            this.updatePaginatedData();
        }
    }

    get disablePrevious(){
        return this.currentPage >= this.totalPages  || this.totalPages === 1;
    }

    get disableNext(){
        return this.currentPage === this.totalPages;
    }

    get hasProjects(){
        return this.filteredProjects && this.filteredProjects.length > 0;
    }

}