import React, { useState, useEffect } from 'react'
import { FiPlus } from 'react-icons/fi'
import EmployeeList from './components/EmployeeList'
import EmployeeForm from './components/EmployeeForm'
import { getEmployees } from './services/api'
import './App.css'

function App() {
  const [employees, setEmployees] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [showForm, setShowForm] = useState(false)
  const [editingEmployee, setEditingEmployee] = useState(null)

  useEffect(() => {
    console.log('App mounted, calling loadEmployees')
    loadEmployees()
  }, [])

  const loadEmployees = async () => {
    try {
      setLoading(true)
      setError(null)
      console.log('Attempting to load employees...')
      const data = await getEmployees()
      console.log('Employees loaded:', data)
      setEmployees(Array.isArray(data) ? data : [])
    } catch (err) {
      console.error('Error loading employees:', err)
      const errorMsg = `Failed to load employees: ${err.message}. Check if backend is running on http://localhost:8000`
      setError(errorMsg)
      // Still set empty array to allow adding employees
      setEmployees([])
    } finally {
      setLoading(false)
    }
  }

  const handleAddEmployee = () => {
    setEditingEmployee(null)
    setShowForm(true)
  }

  const handleEditEmployee = (employee) => {
    setEditingEmployee(employee)
    setShowForm(true)
  }

  const handleFormClose = () => {
    setShowForm(false)
    setEditingEmployee(null)
    loadEmployees()
  }

  return (
    <div className="App">
      <header className="app-header">
        <h1>Employee Management System</h1>
        <button className="btn btn-primary" onClick={handleAddEmployee}>
          <FiPlus size={18} /> Add New Employee
        </button>
      </header>

      <div className="container">
        {error && <div className="error-message">{error}</div>}
        
        {showForm && (
          <EmployeeForm
            employee={editingEmployee}
            onClose={handleFormClose}
            onSuccess={loadEmployees}
          />
        )}

        {loading ? (
          <div className="loading">Loading employees...</div>
        ) : (
          <EmployeeList
            employees={employees}
            onEdit={handleEditEmployee}
            onDelete={loadEmployees}
          />
        )}
      </div>
    </div>
  )
}

export default App
