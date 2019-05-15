# distutils: language = c++

################################
##DEFINITION DES FONCTIONS C++##
################################

from libcpp.vector cimport vector
from libcpp.string cimport string
from libcpp.map cimport map
from libcpp cimport bool
from libcpp.pair cimport pair
from libcpp.list cimport list

import ctypes
ctypes.c_ulong

#import numpy as np
cimport numpy as np

ctypedef np.npy_uint32 UINT32_t

cdef extern from "src/essai.h" :
    cdef vector[string] getEditCostStringOptions()
    cdef vector[string] getMethodStringOptions()
    cdef vector[string] getInitStringOptions()
    cdef bool isInitialized()
    cdef int appelle()
    cdef void restartEnv()
    cdef void loadGXLGraph(string pathFolder, string pathXML)
    cdef vector[size_t] getGraphIds()
    cdef string getGraphClass(size_t id)
    cdef string getGraphName(size_t id)
    cdef size_t addGraph(string name, string classe)
    cdef void addNode(size_t graphId, string nodeId, map[string,string] nodeLabel)
    cdef void addEdge(size_t graphId, string tail, string head, map[string,string] edgeLabel, bool ignoreDuplicates)
    cdef void clearGraph(size_t graphId)
    cdef size_t getGraphInternalId(size_t graphId)
    cdef size_t getGraphNumNodes(size_t graphId)
    cdef size_t getGraphNumEdges(size_t graphId)
    cdef vector[string] getGraphOriginalNodeIds(size_t graphId)
    cdef vector[map[string, string]] getGraphNodeLabels(size_t graphId)
    cdef vector[pair[pair[size_t,size_t], map[string, string]]] getGraphEdges(size_t graphId)
    cdef vector[list[pair[size_t, map[string, string]]]] getGraphAdjacenceList(size_t graphId)
    cdef void setEditCost(string editCost)
    cdef void initEnv(string initOption)
    cdef void setMethod(string method, string options)
    cdef void initMethod()
    cdef double getInitime()
    cdef void runMethod(size_t g, size_t h)
    cdef double getUpperBound(size_t g, size_t h)
    cdef double getLowerBound(size_t g, size_t h)
    cdef vector[np.npy_uint64] getForwardMap(size_t g, size_t h)
    cdef vector[np.npy_uint64] getBackwardMap(size_t g, size_t h)
    cdef vector[vector[np.npy_uint64]] getAllMap(size_t g, size_t h)
    cdef double getRuntime(size_t g, size_t h)
    cdef bool quasimetricCosts()

    
############################################
##REDEFINITION DES FONCTIONS C++ EN PYTHON##
############################################
    
def appel() :
    appelle()

def PyIsInitialized() :
    return isInitialized()

def PyGetEditCostOptions() :
    return getEditCostStringOptions()

def PyGetMethodOptions() :
    return getMethodStringOptions()

def PyGetInitOptions() :
    return getInitStringOptions()

def PyRestartEnv() :
    restartEnv()

def PyLoadGXLGraph(pathFolder, pathXML) :
    loadGXLGraph(pathFolder.encode('utf-8'), pathXML.encode('utf-8'))

def PyGetGraphIds() :
    return getGraphIds()

def PyGetGraphClass(id) :
    return getGraphClass(id)

def PyGetGraphName(id) :
    return getGraphName(id)

def PyAddGraph(name, classe) :
    return addGraph(name,classe)

def PyAddNode(graphID, nodeID, nodeLabel):
    addNode(graphID, nodeID, nodeLabel)

def PyAddEdge(graphID, tail, head, edgeLabel, ignoreDuplicates = True) :
    addEdge(graphID, tail, head, edgeLabel, ignoreDuplicates)

def PyClearGraph(graphID) :
    clearGraph(graphID)

def PyGetGraphInternalId(graphID) :
    return getGraphInternalId(graphID)

def PyGetGraphNumNodes(graphID) :
    return getGraphNumNodes(graphID)

def PyGetGraphNumEdges(graphID) :
    return getGraphNumEdges(graphID)

def PyGetOriginalNodeIds(graphID) :
    return getGraphOriginalNodeIds(graphID)

def PyGetGraphNodeLabels(graphID) :
    return getGraphNodeLabels(graphID)

def PyGetGraphEdges(graphID) :
    return getGraphEdges(graphID)

def PyGetGraphAdjacenceList(graphID) :
    return getGraphAdjacenceList(graphID)

def PySetEditCost(editCost) :
    editCostB = editCost.encode('utf-8')
    if editCostB in listOfEditCostOptions : 
        setEditCost(editCostB)
    else :
        raise EditCostError("This edit cost function doesn't exist, please see listOfEditCostOptions for selecting a edit cost function")

def PyInitEnv(initOption = "EAGER_WITHOUT_SHUFFLED_COPIES") :
    initB = initOption.encode('utf-8')
    if initB in listOfInitOptions : 
        initEnv(initB)
    else :
        raise InitError("This init option doesn't exist, please see listOfInitOptions for selecting an option. You can choose any options.")

def PySetMethod(method, options) :
    methodB = method.encode('utf-8')
    if methodB in listOfMethodOptions :
        setMethod(methodB, options.encode('utf-8'))
    else :
        raise MethodError("This method doesn't exist, please see listOfMethodOptions for selecting a method")

def PyInitMethod() :
    initMethod()

def PyGetInitime() :
    return getInitime()

def PyRunMethod(g, h) :
    runMethod(g,h)

def PyGetUpperBound(g,h) :
    return getUpperBound(g,h)

def PyGetLowerBound(g,h) :
    return getLowerBound(g,h)

def PyGetForwardMap(g,h) :
    return getForwardMap(g,h)

def PyGetBackwardMap(g,h) :
    return getBackwardMap(g,h)

def PyGetAllMap(g,h) :
    return getAllMap(g,h)

def PyGetRuntime(g,h) :
    return getRuntime(g,h)

def PyQuasimetricCost() :
    return quasimetricCosts()

###########################################
##LISTES DES METHODES ET FONCTION DE COUT##
###########################################

listOfEditCostOptions = PyGetEditCostOptions()
listOfMethodOptions = PyGetMethodOptions()
listOfInitOptions = PyGetInitOptions()


########################
##GESTION DES ERREURS ##
########################

class Error(Exception):
    pass

class EditCostError(Error) :
    def __init__(self, message):
        self.message = message
    
class MethodError(Error) :
    def __init__(self, message):
        self.message = message

class InitError(Error) :
    def __init__(self, message):
        self.message = message


##############################
##FONCTIONS PYTHON DE CALCUL##
##############################

    
def computeEditDistanceOnGXlGraphs(pathFolder, pathXML, editCost, method, options, initOption = "EAGER_WITHOUT_SHUFFLED_COPIES") :

    PyRestartEnv()
    
    PyLoadGXLGraph(pathFolder, pathXML)
    listID = PyGetGraphIds()
    print("Number of graphs = " + str(len(listID)))

    PySetEditCost(editCost)
    PyInitEnv(initOption)
    
    PySetMethod(method, options)
    PyInitMethod()

    res = []
    for g in listID :
        for h in listID :
            PyRunMethod(g,h)
            res.append((PyGetUpperBound(g,h), PyGetForwardMap(g,h), PyGetBackwardMap(g,h), PyGetRuntime(g,h)))
            
    return res

    