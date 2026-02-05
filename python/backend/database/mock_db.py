"""
Mock in-memory database for testing without MySQL.
"""

from typing import Optional, List, Dict, Any
from backend.models.employee import Employee


class MockDatabase:
    """In-memory mock database for development."""
    
    _employees: Dict[int, Dict[str, Any]] = {}
    _next_id: int = 1
    
    @classmethod
    def reset(cls):
        """Reset the mock database."""
        cls._employees = {}
        cls._next_id = 1
    
    @classmethod
    def create_employee(cls, employee_data: Dict[str, Any]) -> Optional[Employee]:
        """Create a new employee in mock database."""
        emp_id = cls._next_id
        cls._next_id += 1
        
        # Check for duplicate email
        for emp in cls._employees.values():
            if emp['email'] == employee_data['email']:
                raise ValueError(f"Email {employee_data['email']} already exists")
        
        employee_record = {
            'id': emp_id,
            **employee_data
        }
        cls._employees[emp_id] = employee_record
        
        return Employee.from_dict(employee_record)
    
    @classmethod
    def get_all_employees(cls) -> List[Employee]:
        """Get all employees from mock database."""
        return [Employee.from_dict(emp) for emp in cls._employees.values()]
    
    @classmethod
    def get_employee(cls, employee_id: int) -> Optional[Employee]:
        """Get a specific employee by ID."""
        if employee_id in cls._employees:
            return Employee.from_dict(cls._employees[employee_id])
        return None
    
    @classmethod
    def update_employee(cls, employee_id: int, employee_data: Dict[str, Any]) -> Optional[Employee]:
        """Update an existing employee."""
        if employee_id not in cls._employees:
            return None
        
        # Check for duplicate email (excluding current employee)
        for emp_id, emp in cls._employees.items():
            if emp_id != employee_id and emp['email'] == employee_data.get('email', emp['email']):
                raise ValueError(f"Email {employee_data['email']} already exists")
        
        # Update only provided fields
        for key, value in employee_data.items():
            if value is not None:
                cls._employees[employee_id][key] = value
        
        return Employee.from_dict(cls._employees[employee_id])
    
    @classmethod
    def delete_employee(cls, employee_id: int) -> bool:
        """Delete an employee."""
        if employee_id in cls._employees:
            del cls._employees[employee_id]
            return True
        return False
